# =========================================================
# XP-CLR SELECTION PIPELINE
# =========================================================

library(data.table)
library(dplyr)
library(GenomicRanges)
library(rtracklayer)

project_dir <- "C:/Users/kjlis/Desktop/maize_selection/"

fst_dir <- paste0(project_dir, "/FST_data")
xpehh_dir <- paste0(project_dir, "/XP_EHH_data")
xpclr_dir <- paste0(project_dir, "/XP_CLR_data")

output_dir <- paste0(project_dir, "/results_1")
dir.create(output_dir, showWarnings = FALSE)

gff_file <- paste0(
  project_dir,
  "/ref_genome/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3"
)

annotation_file <- paste0(
  project_dir,
  "/annotations/genes_maizegdb.txt"
)

annotations <- fread(annotation_file)

annotations <- annotations[, c(
  "v5 Gene Model ID",
  "Gene Symbol",
  "Full Name"
)]

colnames(annotations) <- c(
  "Gene_ID",
  "Gene_Symbol",
  "Gene_Name"
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

summary_stats <- data.frame()

for(th_name in names(thresholds)){
  
  threshold_value <- thresholds[[th_name]]
  
  threshold_dir <- paste0(
    output_dir,
    "/",
    th_name
  )
  
  dir.create(
    threshold_dir,
    showWarnings = FALSE
  )
  
  all_xpclr_genes <- data.frame()
  
  all_support <- data.frame()
  
  all_shared <- data.frame()
  
  all_xpclr_fst <- data.frame()
  
  for(comp in comparisons){
    
    cat(
      "\nProcessing:",
      comp,
      "-",
      th_name,
      "\n"
    )
    
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
    
    genes_df <- data.frame(
      Comparison = comp,
      Gene_ID = xpclr_genes
    )
    
    genes_df <- merge(
      genes_df,
      annotations,
      by = "Gene_ID",
      all.x = TRUE
    )
    
    genes_df$Gene_Name[
      is.na(genes_df$Gene_Name) |
        genes_df$Gene_Name == ""
    ] <- genes_df$Gene_Symbol[
      is.na(genes_df$Gene_Name) |
        genes_df$Gene_Name == ""
    ]
    
    genes_df <- genes_df[, c(
      "Comparison",
      "Gene_ID",
      "Gene_Symbol",
      "Gene_Name"
    )]
    
    all_xpclr_genes <- rbind(
      all_xpclr_genes,
      genes_df
    )
    
    support_table <- data.frame(
      Comparison = comp,
      Gene_ID = xpclr_genes,
      FST = xpclr_genes %in% fst_genes,
      XP_EHH = xpclr_genes %in% xpehh_genes
    )
    
    support_table <- merge(
      support_table,
      annotations,
      by = "Gene_ID",
      all.x = TRUE
    )
    
    support_table$Gene_Name[
      is.na(support_table$Gene_Name) |
        support_table$Gene_Name == ""
    ] <- support_table$Gene_Symbol[
      is.na(support_table$Gene_Name) |
        support_table$Gene_Name == ""
    ]
    
    support_table <- support_table[, c(
      "Comparison",
      "Gene_ID",
      "Gene_Symbol",
      "Gene_Name",
      "FST",
      "XP_EHH"
    )]
    
    all_support <- rbind(
      all_support,
      support_table
    )
    
    shared_all <- Reduce(
      intersect,
      list(
        xpclr_genes,
        fst_genes,
        xpehh_genes
      )
    )
    
    shared_xpclr_fst <- intersect(
      xpclr_genes,
      fst_genes
    )
    
    xpclr_fst_df <- data.frame(
      Comparison = comp,
      Gene_ID = shared_xpclr_fst
    )
    
    xpclr_fst_df <- merge(
      xpclr_fst_df,
      annotations,
      by = "Gene_ID",
      all.x = TRUE
    )
    
    xpclr_fst_df$Gene_Name[
      is.na(xpclr_fst_df$Gene_Name) |
        xpclr_fst_df$Gene_Name == ""
    ] <- xpclr_fst_df$Gene_Symbol[
      is.na(xpclr_fst_df$Gene_Name) |
        xpclr_fst_df$Gene_Name == ""
    ]
    
    xpclr_fst_df <- xpclr_fst_df[, c(
      "Comparison",
      "Gene_ID",
      "Gene_Symbol",
      "Gene_Name"
    )]
    
    all_xpclr_fst <- rbind(
      all_xpclr_fst,
      xpclr_fst_df
    )
    
    shared_df <- data.frame(
      Comparison = comp,
      Gene_ID = shared_all
    )
    
    shared_df <- merge(
      shared_df,
      annotations,
      by = "Gene_ID",
      all.x = TRUE
    )
    
    shared_df$Gene_Name[
      is.na(shared_df$Gene_Name) |
        shared_df$Gene_Name == ""
    ] <- shared_df$Gene_Symbol[
      is.na(shared_df$Gene_Name) |
        shared_df$Gene_Name == ""
    ]
    
    shared_df <- shared_df[, c(
      "Comparison",
      "Gene_ID",
      "Gene_Symbol",
      "Gene_Name"
    )]
    
    all_shared <- rbind(
      all_shared,
      shared_df
    )
    
    cat(
      "XPCLR genes:",
      length(xpclr_genes),
      " Shared all:",
      length(shared_all),
      "\n"
    )
    
    cat(
      "XPCLR genes:",
      length(xpclr_genes),
      " Shared all:",
      length(shared_all),
      "\n"
    )
    
    summary_stats <- rbind(
      summary_stats,
      
      data.frame(
        Threshold = th_name,
        Comparison = comp,
        
        XPCLR_genes = length(xpclr_genes),
        
        FST_genes = length(fst_genes),
        
        XP_EHH_genes = length(xpehh_genes),
        
        XPCLR_FST_shared = length(shared_xpclr_fst),
        
        Shared_all = length(shared_all)
      )
    )
  }
  
  fwrite(
    all_xpclr_genes,
    
    paste0(
      threshold_dir,
      "/XP_CLR_",
      th_name,
      "_genes.csv"
    )
  )
  
  fwrite(
    all_support,
    
    paste0(
      threshold_dir,
      "/XP_CLR_",
      th_name,
      "_gene_support.csv"
    )
  )
  
  fwrite(
    all_shared,
    
    paste0(
      threshold_dir,
      "/XP_CLR_",
      th_name,
      "_shared_all.csv"
    )
  )
  
  fwrite(
    all_xpclr_fst,
    
    paste0(
      threshold_dir,
      "/XP_CLR_",
      th_name,
      "_shared_FST.csv"
    )
  )
  
  fwrite(
    summary_stats,
    
    paste0(
      threshold_dir,
      "/XP_CLR_",
      th_name,
      "_summary_statistics.csv"
    )
  )
  
  cat(
    "\nSaved combined files for",
    th_name,
    "\n"
  )
}

cat(
  "\n=================================\n",
  " ANALYSIS FINISHED\n",
  "=================================\n"
)

