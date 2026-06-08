library(GenWin)
library(dplyr)

input_files <- list(
  Pv_Tr    = "/home/kuba/Desktop/XP_EHH/Pv_Tr.norm",
  Tr_Idt_1 = "/home/kuba/Desktop/XP_EHH/Tr_Idt_1.norm",
  Tr_SS_1  = "/home/kuba/Desktop/XP_EHH/Tr_SS_1.norm",
  Idt_1vs2 = "/home/kuba/Desktop/XP_EHH/Idt_1vs2.norm",
  SS_1vs2  = "/home/kuba/Desktop/XP_EHH/SS_1vs2.norm"
)

out_dir <- "/home/kuba/Desktop/XP_EHH"

chr_col <- "chr"
pos_col <- "pos"
stat_col <- "norm_xpehh"

smoothness_value <- 300
chromosomes <- 1:10

analyze_xpehh <- function(file_path, dataset_name, dataset_index, total_datasets) {
  
  message("\n==============================")
  message("Dataset ", dataset_index, "/", total_datasets, ": ", dataset_name)
  message("==============================")
  
  message("Wczytuję plik: ", file_path)
  
  data <- read.table(
    file_path,
    header = TRUE,
    stringsAsFactors = FALSE
  )
  
  if (!chr_col %in% colnames(data)) {
    stop("Brakuje kolumny: ", chr_col, " w pliku ", file_path)
  }
  
  if (!pos_col %in% colnames(data)) {
    stop("Brakuje kolumny: ", pos_col, " w pliku ", file_path)
  }
  
  if (!stat_col %in% colnames(data)) {
    stop("Brakuje kolumny: ", stat_col, " w pliku ", file_path)
  }
  
  data[[chr_col]] <- as.integer(data[[chr_col]])
  data[[pos_col]] <- as.numeric(data[[pos_col]])
  data[[stat_col]] <- as.numeric(data[[stat_col]])
  
  data_clean <- data %>%
    filter(
      !is.na(.data[[chr_col]]),
      !is.na(.data[[pos_col]]),
      !is.na(.data[[stat_col]])
    )
  
  message("Liczba wierszy po czyszczeniu: ", nrow(data_clean))
  message("Podsumowanie ", stat_col, ":")
  print(summary(data_clean[[stat_col]]))
  
  data_clean$abs_xpehh <- abs(data_clean[[stat_col]])
  
  message("Podsumowanie abs_", stat_col, ":")
  print(summary(data_clean$abs_xpehh))
  
  spline_list <- list()
  all_windows <- list()
  
  total_chr <- length(chromosomes)
  chr_counter <- 1
  
  for (i in chromosomes) {
    
    percent_done <- round((chr_counter - 1) / total_chr * 100, 1)
    
    message("\n  Chromosom ", i, " [", chr_counter, "/", total_chr,
            "] — postęp datasetu: ", percent_done, "%")
    
    chr_data <- data_clean %>%
      filter(.data[[chr_col]] == i) %>%
      group_by(.data[[pos_col]]) %>%
      summarise(
        value = mean(abs_xpehh, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      arrange(.data[[pos_col]])
    
    message("  Liczba pozycji po usunięciu duplikatów: ", nrow(chr_data))
    
    if (nrow(chr_data) < 5) {
      warning("Za mało danych dla ", dataset_name, " chr", i, " — pomijam.")
      chr_counter <- chr_counter + 1
      next
    }
    
    spline_obj <- splineAnalyze(
      Y = chr_data$value,
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
        statistic = paste0("abs_", stat_col)
      )
    
    message("  Zakończono chr", i)
    
    chr_counter <- chr_counter + 1
  }
  
  all_windows_df <- bind_rows(all_windows)
  
  output_file <- file.path(
    out_dir,
    paste0("XP_EHH_", dataset_name, "_smoothed.csv")
  )
  
  write.csv(
    all_windows_df,
    output_file,
    row.names = FALSE
  )
  
  message("\nZapisano plik:")
  message(output_file)
  message("Liczba okien w output: ", nrow(all_windows_df))
  
  return(list(
    splines = spline_list,
    windows = all_windows_df
  ))
}

xpehh_results <- list()

total_datasets <- length(input_files)
dataset_counter <- 1

for (dataset_name in names(input_files)) {
  
  xpehh_results[[dataset_name]] <- analyze_xpehh(
    file_path = input_files[[dataset_name]],
    dataset_name = dataset_name,
    dataset_index = dataset_counter,
    total_datasets = total_datasets
  )
  
  dataset_counter <- dataset_counter + 1
}

message("\n==============================")
message("ZAKOŃCZONO ANALIZĘ WSZYSTKICH DATASETÓW")
message("==============================")

