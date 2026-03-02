library(ggplot2)
library(dplyr)
library(readr)

ld_folder <- "/home/kuba/Desktop/full/zea_LD"
files <- list.files(ld_folder, pattern="\\.stat\\.gz$", full.names = TRUE)

groups <- sub("\\.stat\\.gz$", "", basename(files))

ld_list <- lapply(seq_along(files), function(i) {
  df <- read.table(files[i], header = FALSE)
  df <- df[, c("V4", "V2")]
  colnames(df) <- c("Dist", "Mean_r2")
  df$Group <- groups[i]
  return(df)
})

ld_data <- dplyr::bind_rows(ld_list)

ggplot(ld_data, aes(x=Dist, y=Mean_r2, color=Group)) +
  geom_line(linewidth=1.2) +                 
  scale_color_brewer(palette="Set1") +  
  labs(
    x="Distance between SNPs (kb)",
    y=expression(Mean~r^2),
    title="LD Decay in Subpopulations",
    color="Subpopulation"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "right",
    plot.title = element_text(hjust = 0.5, face="bold")
  )