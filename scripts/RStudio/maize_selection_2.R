# =========================================================
# XP-CLR REGION ANALYSIS
# =========================================================

library(data.table)
library(GenomicRanges)

project_dir <- "C:/Users/kjlis/Desktop/maize_selection"

xpclr_dir <- paste0(
  project_dir,
  "/XP_CLR_data"
)

output_dir <- paste0(
  project_dir,
  "/results_2"
)

dir.create(
  output_dir,
  showWarnings = FALSE
)

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

genome_size <- 2135098301

merge_distance <- 10000

analyze_regions <- function(
    file_path,
    top_percent,
    merge_distance = 10000
){
  
  df <- fread(file_path)
  
  df <- df[!is.na(Wstat)]
  
  threshold <- quantile(
    df$Wstat,
    top_percent,
    na.rm = TRUE
  )
  
  top_df <- df[
    Wstat >= threshold,
  ]
  
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
  
  hits <- findOverlaps(
    candidate_regions,
    gr
  )
  
  region_snp_count <- tapply(
    top_df$SNPcount[
      subjectHits(hits)
    ],
    queryHits(hits),
    sum
  )
  
  region_table <- data.frame(
    
    chromosome = as.character(
      seqnames(candidate_regions)
    ),
    
    region_start = start(
      candidate_regions
    ),
    
    region_end = end(
      candidate_regions
    ),
    
    snp_count = as.numeric(
      region_snp_count
    )
  )
  
  region_lengths <- width(
    candidate_regions
  )
  
  stats <- data.frame(
    
    top_windows =
      nrow(top_df),
    
    n_regions =
      length(candidate_regions),
    
    mean_kb =
      round(
        mean(region_lengths) / 1000,
        2
      ),
    
    median_kb =
      round(
        median(region_lengths) / 1000,
        2
      ),
    
    max_kb =
      round(
        max(region_lengths) / 1000,
        2
      ),
    
    total_mb =
      round(
        sum(region_lengths) / 1e6,
        3
      ),
    
    genome_percent =
      round(
        100 *
          sum(region_lengths) /
          genome_size,
        3
      )
  )
  
  return(
    list(
      stats = stats,
      regions = region_table
    )
  )
}

for(th_name in names(thresholds)){
  
  threshold_value <- thresholds[[th_name]]
  
  results <- data.frame()
  
  all_regions <- data.frame()
  
  threshold_dir <- paste0(
    output_dir,
    "/",
    th_name
  )
  
  dir.create(
    threshold_dir,
    showWarnings = FALSE
  )
  
  for(comp in comparisons){
    
    cat(
      "\nProcessing:",
      comp,
      "-",
      th_name,
      "\n"
    )
    
    file <- paste0(
      xpclr_dir,
      "/XP_CLR_",
      comp,
      "_smoothed.csv"
    )
    
    res <- analyze_regions(
      file_path = file,
      top_percent = threshold_value,
      merge_distance = merge_distance
    )
    
    stats <- res$stats
    
    stats$comparison <- comp
    
    stats$threshold <- th_name
    
    results <- rbind(
      results,
      stats
    )
    
    region_df <- res$regions
    
    region_df$comparison <- comp
    
    all_regions <- rbind(
      all_regions,
      region_df
    )
    
    cat(
      "Regions:",
      stats$n_regions,
      "\n"
    )
  }
  
  results <- results[, c(
    "comparison",
    "threshold",
    "top_windows",
    "n_regions",
    "mean_kb",
    "median_kb",
    "max_kb",
    "total_mb",
    "genome_percent"
  )]
  
  fwrite(
    results,
    
    paste0(
      threshold_dir,
      "/XPCLR_",
      th_name,
      "_region_statistics.csv"
    )
  )
  
  all_regions <- all_regions[, c(
    "comparison",
    "chromosome",
    "region_start",
    "region_end",
    "snp_count"
  )]
  
  fwrite(
    all_regions,
    
    paste0(
      threshold_dir,
      "/XPCLR_",
      th_name,
      "_regions.csv"
    )
  )
}

cat(
  "\n=================================\n",
  "REGION ANALYSIS FINISHED\n",
  "=================================\n"
)

