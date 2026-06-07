# =========================================================
# FULL PIPELINE:
# FST + XP-EHH + XP-CLR
# Candidate genes under selection
# =========================================================

# =========================================================
# 1. LOAD LIBRARIES
# =========================================================

library(data.table)
library(dplyr)
library(GenomicRanges)
library(rtracklayer)

# =========================================================
# 2. DEFINE PATHS
# =========================================================

# Main project directory
project_dir <- "/home/kuba/Desktop/maize_selection"

# Method-specific folders
fst_dir <- paste0(project_dir, "/FST_data/")
xpehh_dir <- paste0(project_dir, "/XP_EHH_data/")
xpclr_dir <- paste0(project_dir, "/XP_CLR_data/")

# Output directory
output_dir <- paste0(project_dir, "/selection_results/")

dir.create(output_dir, showWarnings = FALSE)

# Genome annotation
gff_file <- paste0(
  project_dir,
  "/ref_genome/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3"
)

# =========================================================
# 3. LOAD GENE ANNOTATION
# =========================================================

gff <- import(gff_file)

genes <- gff[gff$type == "gene"]

# =========================================================
# 4. DEFINE COMPARISONS
# =========================================================

comparisons <- c(
  "Pv_Tr",
  "Tr_Idt_1",
  "Tr_SS_1",
  "Idt_1vs2",
  "SS_1vs2"
)

# =========================================================
# 5. FUNCTION FOR ANALYSIS
# =========================================================

analyze_selection_scan <- function(
    file_path,
    method_name,
    comparison_name,
    score_column,
    use_absolute = FALSE,
    top_percent = 0.95,
    extend_bp = 50000
) {
  
  cat("\n")
  cat("=============================\n")
  cat(method_name, "-", comparison_name, "\n")
  cat("=============================\n")
  
  # -------------------------------------------------------
  # LOAD DATA
  # -------------------------------------------------------
  
  df <- fread(file_path)
  
  # -------------------------------------------------------
  # CLEAN DATA
  # -------------------------------------------------------
  
  df <- df %>%
    filter(!is.na(.data[[score_column]]))
  
  # Remove chr prefix if present
  df$chromosome <- gsub(
    "chr",
    "",
    df$chromosome
  )
  
  # -------------------------------------------------------
  # HANDLE XP-EHH
  # -------------------------------------------------------
  
  if(use_absolute == TRUE) {
    
    df$ABS_SCORE <- abs(df[[score_column]])
    
    threshold <- quantile(
      df$ABS_SCORE,
      top_percent,
      na.rm = TRUE
    )
    
    top_df <- df %>%
      filter(ABS_SCORE >= threshold)
    
  } else {
    
    threshold <- quantile(
      df[[score_column]],
      top_percent,
      na.rm = TRUE
    )
    
    top_df <- df %>%
      filter(.data[[score_column]] >= threshold)
  }
  
  # -------------------------------------------------------
  # CONVERT TO GRanges
  # -------------------------------------------------------
  
  gr <- GRanges(
    seqnames = top_df$chromosome,
    
    ranges = IRanges(
      start = top_df$WindowStart,
      end = top_df$WindowStop
    ),
    
    score = top_df[[score_column]]
  )
  
  # -------------------------------------------------------
  # EXTEND REGIONS
  # -------------------------------------------------------
  
  gr_extended <- resize(
    gr,
    width = width(gr) + (extend_bp * 2),
    fix = "center"
  )
  
  # -------------------------------------------------------
  # FIND OVERLAPPING GENES
  # -------------------------------------------------------
  
  hits <- findOverlaps(
    gr_extended,
    genes
  )
  
  cat(
    "Overlaps:",
    length(hits),
    "\n"
  )
  
  candidate_genes <- unique(
    mcols(genes)$ID[subjectHits(hits)]
  )
  
  cat(
    "Genes:",
    length(candidate_genes),
    "\n"
  )
  
  # -------------------------------------------------------
  # CREATE OUTPUT FOLDER
  # -------------------------------------------------------
  
  method_output <- paste0(
    output_dir,
    "/",
    method_name
  )
  
  dir.create(
    method_output,
    showWarnings = FALSE
  )
  
  # -------------------------------------------------------
  # SAVE TOP WINDOWS
  # -------------------------------------------------------
  
  write.csv(
    top_df,
    
    paste0(
      method_output,
      "/",
      comparison_name,
      "_top5_windows.csv"
    ),
    
    row.names = FALSE
  )
  
  # -------------------------------------------------------
  # SAVE CANDIDATE GENES
  # -------------------------------------------------------
  
  write.csv(
    data.frame(
      Gene = candidate_genes
    ),
    
    paste0(
      method_output,
      "/",
      comparison_name,
      "_candidate_genes.csv"
    ),
    
    row.names = FALSE
  )
  
  # -------------------------------------------------------
  # PRINT SUMMARY
  # -------------------------------------------------------
  
  cat("Threshold:", threshold, "\n")
  
  cat(
    "Top windows:",
    nrow(top_df),
    "\n"
  )
  
  cat(
    "Candidate genes:",
    length(candidate_genes),
    "\n"
  )
  
  # -------------------------------------------------------
  # RETURN RESULTS
  # -------------------------------------------------------
  
  return(list(
    
    method = method_name,
    
    comparison = comparison_name,
    
    top_windows = top_df,
    
    genes = candidate_genes
  ))
}

# =========================================================
# 6. ANALYZE XP-CLR
# =========================================================

XPCLR_results <- list()

for(comp in comparisons) {
  
  file <- paste0(
    xpclr_dir,
    "/XP_CLR_",
    comp,
    "_smoothed.csv"
  )
  
  XPCLR_results[[comp]] <- analyze_selection_scan(
    file_path = file,
    method_name = "XPCLR",
    comparison_name = comp,
    score_column = "Wstat",
    use_absolute = FALSE
  )
}

# =========================================================
# 7. ANALYZE FST
# =========================================================

FST_results <- list()

for(comp in comparisons) {
  
  file <- paste0(
    fst_dir,
    "/FST_",
    "/",
    comp,
    "_smoothed.csv"
  )
  
  FST_results[[comp]] <- analyze_selection_scan(
    file_path = file,
    
    method_name = "FST",
    
    comparison_name = comp,
    
    score_column = "FST",
    
    use_absolute = FALSE
  )
}

# =========================================================
# 8. ANALYZE XP-EHH
# =========================================================

XPEHH_results <- list()

for(comp in comparisons) {
  
  file <- paste0(
    xpehh_dir,
    "/XP_EHH_",
    "/",
    comp,
    "_smoothed.csv"
  )
  
  XPEHH_results[[comp]] <- analyze_selection_scan(
    file_path = file,
    
    method_name = "XPEHH",
    
    comparison_name = comp,
    
    score_column = "XPEHH",
    
    use_absolute = TRUE
  )
}

# =========================================================
# 9. COMPARE METHODS
# =========================================================

comparison_output <- paste0(
  output_dir,
  "/Method_overlap/"
)

dir.create(
  comparison_output,
  showWarnings = FALSE
)

for(comp in comparisons) {
  
  cat("\n")
  cat("===================================\n")
  cat("OVERLAP:", comp, "\n")
  cat("===================================\n")
  
  xpclr_genes <- XPCLR_results[[comp]]$genes
  
  fst_genes <- FST_results[[comp]]$genes
  
  xpehh_genes <- XPEHH_results[[comp]]$genes
  
  # -------------------------------------------------------
  # SHARED GENES
  # -------------------------------------------------------
  
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
  
  shared_xpclr_xpehh <- intersect(
    xpclr_genes,
    xpehh_genes
  )
  
  # -------------------------------------------------------
  # CREATE SUMMARY TABLE
  # -------------------------------------------------------
  
  all_genes <- unique(c(
    xpclr_genes,
    fst_genes,
    xpehh_genes
  ))
  
  summary_table <- data.frame(
    
    Gene = all_genes,
    
    XPCLR = all_genes %in% xpclr_genes,
    
    FST = all_genes %in% fst_genes,
    
    XPEHH = all_genes %in% xpehh_genes
  )
  
  summary_table$Detected_by_all <- (
    summary_table$XPCLR &
      summary_table$FST &
      summary_table$XPEHH
  )
  
  summary_table$N_methods <- rowSums(
    summary_table[,2:4]
  )
  
  # -------------------------------------------------------
  # SAVE SUMMARY
  # -------------------------------------------------------
  
  write.csv(
    
    summary_table,
    
    paste0(
      comparison_output,
      "/",
      comp,
      "_overlap_summary.csv"
    ),
    
    row.names = FALSE
  )
  
  # -------------------------------------------------------
  # SAVE SHARED GENES
  # -------------------------------------------------------
  
  write.csv(
    
    data.frame(
      Gene = shared_all
    ),
    
    paste0(
      comparison_output,
      "/",
      comp,
      "_shared_all.csv"
    ),
    
    row.names = FALSE
  )
  
  # -------------------------------------------------------
  # PRINT SUMMARY
  # -------------------------------------------------------
  
  cat(
    "XP-CLR genes:",
    length(xpclr_genes),
    "\n"
  )
  
  cat(
    "FST genes:",
    length(fst_genes),
    "\n"
  )
  
  cat(
    "XP-EHH genes:",
    length(xpehh_genes),
    "\n"
  )
  
  cat(
    "Shared across ALL methods:",
    length(shared_all),
    "\n"
  )
}

# =========================================================
# 10. OPTIONAL:
# SAVE COMPLETE OBJECTS
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
cat("SELECTION SCAN ANALYSIS FINISHED\n")
cat("=====================================\n")