################################


library(GenWin)
library(dplyr)

input_files <- list(
  Pv_Tr    = "/home/kuba/Desktop/Parviglumis_Tropical.fst",
  Tr_Idt_1 = "/home/kuba/Desktop/Tropical_Iodent_1.fst",
  Tr_SS_1  = "/home/kuba/Desktop/Tropical_SS_1.fst",
  Idt_1vs2 = "/home/kuba/Desktop/Iodent_1vs2.fst",
  SS_1vs2  = "/home/kuba/Desktop/SS_1vs2.fst"
)

out_dir <- "/home/kuba/Desktop"

chr_col <- "Chr"
pos_col <- "bp"
stat_col <- "Fst"

smoothness_value <- 300
chromosomes <- 1:10

analyze_fst <- function(file_path, dataset_name) {
  
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
  
  data[[stat_col]] <- pmax(data[[stat_col]], 0)
  
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
    paste0("FST_", dataset_name, "_smoothed.csv")
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

fst_results <- list()

for (dataset_name in names(input_files)) {
  
  fst_results[[dataset_name]] <- analyze_fst(
    file_path = input_files[[dataset_name]],
    dataset_name = dataset_name
  )
}


################################


library(GenWin)
library(dplyr)

input_files <- list(
  Idt_1_SS_1    = "/home/kuba/Desktop/Iodent_1_SS_1.fst",
  Idt_2_SS_2 = "/home/kuba/Desktop/Iodent_2_SS_2.fst",
  Idt_1_NSS  = "/home/kuba/Desktop/Iodent_1_NSS.fst",
  Idt_2_NSS = "/home/kuba/Desktop/Iodent_2_NSS.fst",
  SS_1_NSS  = "/home/kuba/Desktop/SS_1_NSS.fst",
  SS_2_NSS = "/home/kuba/Desktop/SS_1_NSS.fst"
)

out_dir <- "/home/kuba/Desktop"

chr_col <- "Chr"
pos_col <- "bp"
stat_col <- "Fst"

smoothness_value <- 300
chromosomes <- 1:10

analyze_fst <- function(file_path, dataset_name) {
  
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
  
  data[[stat_col]] <- pmax(data[[stat_col]], 0)
  
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
    paste0("FST_", dataset_name, "_smoothed.csv")
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

fst_results <- list()

for (dataset_name in names(input_files)) {
  
  fst_results[[dataset_name]] <- analyze_fst(
    file_path = input_files[[dataset_name]],
    dataset_name = dataset_name
  )
}

