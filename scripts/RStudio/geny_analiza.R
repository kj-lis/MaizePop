# =========================================================
# FULL PIPELINE
# XP-CLR + FST + XP-EHH
# TOP 1% WINDOWS -> REGIONS -> GENES
# =========================================================

library(data.table)
library(dplyr)
library(GenomicRanges)
library(rtracklayer)

# =========================================================
# PATHS
# =========================================================

project_dir <- "/home/kuba/Desktop/maize_selection"

fst_dir <- paste0(project_dir, "/FST_data")
xpehh_dir <- paste0(project_dir, "/XP_EHH_data")
xpclr_dir <- paste0(project_dir, "/XP_CLR_data")

output_dir <- paste0(project_dir, "/selection_results")

dir.create(output_dir, showWarnings = FALSE)

gff_file <- paste0(
  project_dir,
  "/ref_genome/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3"
)

# =========================================================
# LOAD GENE ANNOTATION
# =========================================================

gff <- import(gff_file)

genes <- gff[gff$type == "gene"]

cat(
  "Loaded genes:",
  length(genes),
  "\n"
)

# =========================================================
# COMPARISONS
# =========================================================

comparisons <- c(
  "Pv_Tr",
  "Tr_Idt_1",
  "Tr_SS_1",
  "Idt_1vs2",
  "SS_1vs2"
)

# =========================================================
# ANALYSIS FUNCTION
# =========================================================

analyze_selection_scan <- function(
    file_path,
    method_name,
    comparison_name,
    score_column = "Wstat",
    use_absolute = FALSE,
    top_percent = 0.99,
    extend_bp = 50000,
    merge_distance = 10000
) {
  
  cat("\n")
  cat("=====================================\n")
  cat(method_name, "-", comparison_name, "\n")
  cat("=====================================\n")
  
  df <- fread(file_path)
  
  df <- df %>%
    filter(!is.na(.data[[score_column]]))
  
  if(use_absolute){
    
    df$ScoreUsed <- abs(df[[score_column]])
    
  } else {
    
    df$ScoreUsed <- df[[score_column]]
    
  }
  
  # =====================================================
  # TOP 1%
  # =====================================================
  
  threshold <- quantile(
    df$ScoreUsed,
    top_percent,
    na.rm = TRUE
  )
  
  top_df <- df %>%
    filter(ScoreUsed >= threshold)
  
  cat(
    "Threshold:",
    threshold,
    "\n"
  )
  
  cat(
    "Top windows:",
    nrow(top_df),
    "\n"
  )
  
  # =====================================================
  # WINDOWS -> GRanges
  # =====================================================
  
  gr <- GRanges(
    
    seqnames = top_df$chromosome,
    
    ranges = IRanges(
      start = top_df$WindowStart,
      end = top_df$WindowStop
    ),
    
    score = top_df$ScoreUsed
  )
  
  # =====================================================
  # MERGE ADJACENT WINDOWS
  # =====================================================
  
  candidate_regions <- reduce(
    gr,
    min.gapwidth = merge_distance
  )
  
  cat(
    "Candidate regions:",
    length(candidate_regions),
    "\n"
  )
  
  # =====================================================
  # EXTEND REGIONS ±50 kb
  # =====================================================
  
  candidate_regions <- resize(
    candidate_regions,
    width = width(candidate_regions) +
      (extend_bp * 2),
    fix = "center"
  )
  
  # =====================================================
  # FIND GENES
  # =====================================================
  
  hits <- findOverlaps(
    candidate_regions,
    genes
  )
  
  candidate_genes <- unique(
    mcols(genes)$ID[
      subjectHits(hits)
    ]
  )
  
  cat(
    "Overlaps:",
    length(hits),
    "\n"
  )
  
  cat(
    "Candidate genes:",
    length(candidate_genes),
    "\n"
  )
  
  # =====================================================
  # SAVE RESULTS
  # =====================================================
  
  method_output <- paste0(
    output_dir,
    "/",
    method_name
  )
  
  dir.create(
    method_output,
    showWarnings = FALSE
  )
  
  fwrite(
    top_df,
    paste0(
      method_output,
      "/",
      comparison_name,
      "_top1_windows.csv"
    )
  )
  
  region_df <- data.frame(
    chromosome = as.character(seqnames(candidate_regions)),
    start = start(candidate_regions),
    end = end(candidate_regions)
  )
  
  fwrite(
    region_df,
    paste0(
      method_output,
      "/",
      comparison_name,
      "_candidate_regions.csv"
    )
  )
  
  fwrite(
    data.frame(
      Gene = candidate_genes
    ),
    paste0(
      method_output,
      "/",
      comparison_name,
      "_candidate_genes.csv"
    )
  )
  
  return(
    list(
      
      method = method_name,
      
      comparison = comparison_name,
      
      threshold = threshold,
      
      top_windows = top_df,
      
      candidate_regions = candidate_regions,
      
      genes = candidate_genes
    )
  )
}

# =========================================================
# XP-CLR
# =========================================================

XPCLR_results <- list()

for(comp in comparisons){
  
  file <- paste0(
    xpclr_dir,
    "/XP_CLR_",
    comp,
    "_smoothed.csv"
  )
  
  XPCLR_results[[comp]] <-
    analyze_selection_scan(
      file_path = file,
      method_name = "XPCLR",
      comparison_name = comp,
      score_column = "Wstat",
      use_absolute = FALSE,
      top_percent = 0.99
    )
}

# =========================================================
# FST
# =========================================================

FST_results <- list()

for(comp in comparisons){
  
  file <- paste0(
    fst_dir,
    "/FST_",
    comp,
    "_smoothed.csv"
  )
  
  FST_results[[comp]] <-
    analyze_selection_scan(
      file_path = file,
      method_name = "FST",
      comparison_name = comp,
      score_column = "Wstat",
      use_absolute = FALSE,
      top_percent = 0.99
    )
}

# =========================================================
# XP-EHH
# =========================================================

XPEHH_results <- list()

for(comp in comparisons){
  
  file <- paste0(
    xpehh_dir,
    "/XP_EHH_",
    comp,
    "_smoothed.csv"
  )
  
  XPEHH_results[[comp]] <-
    analyze_selection_scan(
      file_path = file,
      method_name = "XPEHH",
      comparison_name = comp,
      score_column = "Wstat",
      use_absolute = TRUE,
      top_percent = 0.99
    )
}

# =========================================================
# METHOD OVERLAP
# =========================================================

comparison_output <- paste0(
  output_dir,
  "/Method_overlap"
)

dir.create(
  comparison_output,
  showWarnings = FALSE
)

for(comp in comparisons){
  
  xpclr_genes <- XPCLR_results[[comp]]$genes
  fst_genes <- FST_results[[comp]]$genes
  xpehh_genes <- XPEHH_results[[comp]]$genes
  
  shared_all <- Reduce(
    intersect,
    list(
      xpclr_genes,
      fst_genes,
      xpehh_genes
    )
  )
  
  all_genes <- unique(
    c(
      xpclr_genes,
      fst_genes,
      xpehh_genes
    )
  )
  
  summary_table <- data.frame(
    
    Gene = all_genes,
    
    XPCLR = all_genes %in% xpclr_genes,
    
    FST = all_genes %in% fst_genes,
    
    XPEHH = all_genes %in% xpehh_genes
  )
  
  summary_table$Detected_by_all <-
    summary_table$XPCLR &
    summary_table$FST &
    summary_table$XPEHH
  
  summary_table$N_methods <-
    rowSums(summary_table[,2:4])
  
  fwrite(
    summary_table,
    paste0(
      comparison_output,
      "/",
      comp,
      "_overlap_summary.csv"
    )
  )
  
  fwrite(
    data.frame(
      Gene = shared_all
    ),
    paste0(
      comparison_output,
      "/",
      comp,
      "_shared_all_methods.csv"
    )
  )
  
  cat(
    "\n",
    comp,
    " shared genes:",
    length(shared_all),
    "\n"
  )
}

# =========================================================
# SAVE R OBJECTS
# =========================================================

save(
  XPCLR_results,
  FST_results,
  XPEHH_results,
  
  file = paste0(
    output_dir,
    "/all_selection_results.RData"
  )
)

# =========================================================
# FINISHED
# =========================================================

cat("\n")
cat("=====================================\n")
cat("SELECTION ANALYSIS FINISHED\n")
cat("=====================================\n")

