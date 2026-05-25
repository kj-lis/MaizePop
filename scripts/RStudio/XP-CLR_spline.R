library(GenWin)
library(dplyr)

input_files <- list(
  Pv_Tr    = "/home/kuba/Desktop/Pv_Tr.wtclr.txt",
  Tr_Idt_1 = "/home/kuba/Desktop/Tr_Idt_1.wtclr.txt",
  Tr_SS_1  = "/home/kuba/Desktop/Tr_SS_1.wtclr.txt",
  Idt_1vs2 = "/home/kuba/Desktop/Idt_1vs2.wtclr.txt",
  SS_1vs2  = "/home/kuba/Desktop/SS_1vs2.wtclr.txt"
)

out_dir <- "/home/kuba/Desktop"

chr_col <- "Chr"
pos_col <- "bp"

stat_col <- "xpclr"

smoothness_value <- 300
chromosomes <- 1:10

analyze_xpclr <- function(file_path, dataset_name) {
  
  message("Analizuję: ", dataset_name)
  
  data <- read.table(file_path, header = TRUE)
  
  if (!chr_col %in% colnames(data)) {
    stop("Brakuje kolumny: ", chr_col, " w pliku ", file_path)
  }
  
  if (!pos_col %in% colnames(data)) {
    stop("Brakuje kolumny: ", pos_col, " w pliku ", file_path)
  }
  
  if (!stat_col %in% colnames(data)) {
    stop("Brakuje kolumny: ", stat_col, " w pliku ", file_path)
  }
  
  data_clean <- data %>%
    filter(
      !is.na(.data[[chr_col]]),
      !is.na(.data[[pos_col]]),
      !is.na(.data[[stat_col]])
    )
  
  message("Podsumowanie ", stat_col, " dla ", dataset_name, ":")
  print(summary(data_clean[[stat_col]]))
  
  spline_list <- list()
  all_windows <- list()
  
  for (i in chromosomes) {
    
    chr_data <- data_clean %>%
      filter(.data[[chr_col]] == i) %>%
      arrange(.data[[pos_col]])
    
    if (nrow(chr_data) < 5) {
      warning("Za mało danych dla ", dataset_name, " chr", i, " — pomijam.")
      next
    }
    
    spline_obj <- splineAnalyze(
      Y = chr_data[[stat_col]],
      map = chr_data[[pos_col]],
      smoothness = smoothness_value,
      plotRaw = TRUE,
      plotWindows = TRUE,
      method = 4
    )
    
    spline_list[[paste0("chr", i)]] <- spline_obj
    
    window_data <- spline_obj[["windowData"]]
    
    all_windows[[paste0("chr", i)]] <- window_data %>%
      mutate(
        chromosome = paste0("chr", i),
        dataset = dataset_name,
        statistic = stat_col
      )
  }
  
  all_windows_df <- bind_rows(all_windows)
  
  output_file <- file.path(
    out_dir,
    paste0("XP_CLR_", dataset_name, "_smoothed.csv")
  )
  
  write.csv(
    all_windows_df,
    output_file,
    row.names = FALSE
  )
  
  message("Zapisano: ", output_file)
  
  return(list(
    splines = spline_list,
    windows = all_windows_df
  ))
}

xpclr_results <- list()

for (dataset_name in names(input_files)) {
  
  xpclr_results[[dataset_name]] <- analyze_xpclr(
    file_path = input_files[[dataset_name]],
    dataset_name = dataset_name
  )
}