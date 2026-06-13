# =========================================================
# XP-CLR SELECTION PIPELINE
# TOP 1% and TOP 5%
# =========================================================

library(data.table)
library(dplyr)
library(GenomicRanges)
library(rtracklayer)

project_dir <- "C:/Users/kjlis/Desktop/maize_selection/"

fst_dir <- paste0(project_dir, "/FST_data")
xpehh_dir <- paste0(project_dir, "/XP_EHH_data")
xpclr_dir <- paste0(project_dir, "/XP_CLR_data")

output_dir <- paste0(project_dir, "/selection_results")
dir.create(output_dir, showWarnings = FALSE)

gff_file <- paste0(
  project_dir,
  "/ref_genome/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3"
)

gff <- import(gff_file)
genes <- gff[gff$type == "gene"]

comparisons <- c(
  "Pv_Tr",
  "Tr_Idt_1",
  "Tr_SS_1",
  "Idt_1vs2",
  "SS_1vs2"
)

thresholds <- list(
  top1 = 0.99,
  top5 = 0.95
)

get_candidate_genes <- function(
    file_path,
    score_column = "Wstat",
    use_absolute = FALSE,
    top_percent = 0.99,
    extend_bp = 10000,
    merge_distance = 10000
){
  
  df <- fread(file_path)
  
  df <- df[!is.na(df[[score_column]])]
  
  if(use_absolute){
    df$ScoreUsed <- abs(df[[score_column]])
  } else {
    df$ScoreUsed <- df[[score_column]]
  }
  
  threshold <- quantile(
    df$ScoreUsed,
    top_percent,
    na.rm = TRUE
  )
  
  top_df <- df[df$ScoreUsed >= threshold, ]
  
  gr <- GRanges(
    seqnames = top_df$chromosome,
    ranges = IRanges(
      start = top_df$WindowStart,
      end = top_df$WindowStop
    )
  )
  
  candidate_regions <- reduce(
    gr,
    min.gapwidth = merge_distance
  )
  
  candidate_regions <- resize(
    candidate_regions,
    width = width(candidate_regions) + (extend_bp * 2),
    fix = "center"
  )
  
  hits <- findOverlaps(
    candidate_regions,
    genes
  )
  
  unique(
    mcols(genes)$ID[subjectHits(hits)]
  )
}

for(th_name in names(thresholds)){
  
  threshold_value <- thresholds[[th_name]]
  
  threshold_dir <- paste0(
    output_dir,
    "/",
    th_name
  )
  
  dir.create(threshold_dir, showWarnings = FALSE)
  
  for(comp in comparisons){
    
    cat("\nProcessing:", comp, "-", th_name, "\n")
    
    xpclr_file <- paste0(
      xpclr_dir,
      "/XP_CLR_",
      comp,
      "_smoothed.csv"
    )
    
    fst_file <- paste0(
      fst_dir,
      "/FST_",
      comp,
      "_smoothed.csv"
    )
    
    xpehh_file <- paste0(
      xpehh_dir,
      "/XP_EHH_",
      comp,
      "_smoothed.csv"
    )
    
    xpclr_genes <- get_candidate_genes(
      xpclr_file,
      top_percent = threshold_value,
      use_absolute = FALSE
    )
    
    fst_genes <- get_candidate_genes(
      fst_file,
      top_percent = threshold_value,
      use_absolute = FALSE
    )
    
    xpehh_genes <- get_candidate_genes(
      xpehh_file,
      top_percent = threshold_value,
      use_absolute = TRUE
    )
    
    comp_dir <- paste0(
      threshold_dir,
      "/",
      comp
    )
    
    dir.create(comp_dir, showWarnings = FALSE)
    
    fwrite(
      data.frame(
        Gene = xpclr_genes
      ),
      paste0(
        comp_dir,
        "/",
        comp,
        "_XPCLR_",
        th_name,
        "_genes.csv"
      )
    )
    
    support_table <- data.frame(
      Gene = xpclr_genes,
      FST = xpclr_genes %in% fst_genes,
      XPEHH = xpclr_genes %in% xpehh_genes
    )
    
    fwrite(
      support_table,
      paste0(
        comp_dir,
        "/",
        comp,
        "_XPCLR_",
        th_name,
        "_gene_support.csv"
      )
    )
    
    shared_all <- Reduce(
      intersect,
      list(
        xpclr_genes,
        fst_genes,
        xpehh_genes
      )
    )
    
    fwrite(
      data.frame(
        Gene = shared_all
      ),
      paste0(
        comp_dir,
        "/",
        comp,
        "_XPCLR_",
        th_name,
        "_shared_all.csv"
      )
    )
    
    cat(
      "XPCLR genes:", length(xpclr_genes),
      " Shared all:", length(shared_all), "\n"
    )
  }
}

cat("\nFinished.\n")

