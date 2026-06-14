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
    
    SNP_count = as.numeric(
      region_snp_count
    )
  )
  
  region_lengths <- width(
    candidate_regions
  )
  
  stats <- data.frame(
    
    N_regions =
      length(candidate_regions),
    
    Mean_kb =
      round(
        mean(region_lengths)/1000,
        2
      ),
    
    Median_kb =
      round(
        median(region_lengths)/1000,
        2
      ),
    
    Max_kb =
      round(
        max(region_lengths)/1000,
        2
      ),
    
    Total_Mb =
      round(
        sum(region_lengths)/1e6,
        3
      ),
    
    Genome_percent =
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
    
    stats$Comparison <- comp
    
    stats$Threshold <- th_name
    
    results <- rbind(
      results,
      stats
    )
    
    fwrite(
      res$regions,
      
      paste0(
        threshold_dir,
        "/",
        comp,
        "_",
        th_name,
        "_regions.csv"
      )
    )
    
    cat(
      "Regions:",
      stats$N_regions,
      "\n"
    )
  }
  
  results <- results[, c(
    "Comparison",
    "Threshold",
    "N_regions",
    "Mean_kb",
    "Median_kb",
    "Max_kb",
    "Total_Mb",
    "Genome_percent"
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
}

cat(
  "\n=================================\n",
  "REGION ANALYSIS FINISHED\n",
  "=================================\n"
)

