ld_list <- lapply(seq_along(files), function(i) {
  df <- read.table(files[i], header = FALSE, sep = "\t")
  colnames(df) <- c("Dist", "Mean_r2", "N")  # dostosuj do liczby kolumn
  df$Group <- groups[i]
  return(df)
})

ld_data <- dplyr::bind_rows(ld_list)

ggplot(ld_data, aes(x = dist, y = Mean_r2, color = Group)) +
  geom_line(linewidth = 1.2) +
  scale_color_brewer(palette = "Set1") +
  labs(
    x = "Distance between SNPs (kb)",
    y = expression(Mean~r^2),
    title = "LD Decay in Subpopulations",
    color = "Subpopulation"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "right",
    plot.title = element_text(hjust = 0.5, face = "bold")
  )




# biblioteki
library(data.table)
library(ggplot2)

# folder z plikami
ld_folder <- "/home/kuba/Desktop/full/zea_LD"
files <- list.files(ld_folder, pattern="\\.stat\\.gz$", full.names = TRUE)
groups <- sub("\\.stat\\.gz$", "", basename(files))

# wczytanie i przygotowanie danych
ld_list <- lapply(seq_along(files), function(i) {
  df <- read.table(files[i], header = FALSE, sep = "\t")
  
  # wybieramy kolumny Dist (V4) i Mean_r2 (V2)
  df <- df[, c(4,2)]
  colnames(df) <- c("Dist", "Mean_r2")
  
  # konwersja na liczby
  df$Dist <- as.numeric(df$Dist)
  df$Mean_r2 <- as.numeric(df$Mean_r2)
  
  # dodajemy nazwę populacji
  df$Group <- groups[i]
  
  return(df)
})

# łączenie wszystkich plików w jedną tabelę
ld_data <- rbindlist(ld_list)

# agregacja po binach 5 kb
ld_bin <- ld_data[, .(Mean_r2_bin = mean(Mean_r2)), by = .(Group, Dist_bin = floor(Dist/5000)*5000)]
setorder(ld_bin, Group, Dist_bin)  # sortowanie po Dist w każdej grupie

# wykres LD decay
ggplot(ld_data, aes(x = Dist, y = Mean_r2, color = Group)) +
  geom_smooth(se = FALSE, method = "loess", span = 0.2) +
  scale_color_brewer(palette = "Set1") +
  labs(
    x = "Distance between SNPs (bp)",
    y = expression(Mean~r^2),
    title = "LD decay in subpopulations",
    color = "Subpopulation"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 1),
    legend.position = "right",
    plot.title = element_text(hjust = 0.5, face = "bold")
  )