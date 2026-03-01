LD1 <- read.table("/home/kuba/Desktop/full/zea_LD/zea_1_LD.stat.gz", header=TRUE)
LD2 <- read.table("/home/kuba/Desktop/full/zea_LD/zea_2_LD.stat.gz", header=TRUE)
LD3 <- read.table("/home/kuba/Desktop/full/zea_LD/zea_3_LD.stat.gz", header=TRUE)
LD4 <- read.table("/home/kuba/Desktop/full/zea_LD/zea_4_LD.stat.gz", header=TRUE)
LD5 <- read.table("/home/kuba/Desktop/full/zea_LD/zea_5_LD.stat.gz", header=TRUE)

plot(LD1$Dist, LD1$Mean_r2, type="l")
plot(LD2$Dist, LD2$Mean_r2, type="l")
plot(LD3$Dist, LD3$Mean_r2, type="l")
plot(LD4$Dist, LD4$Mean_r2, type="l")
plot(LD5$Dist, LD5$Mean_r2, type="l")


###############################################


library(ggplot2)
library(dplyr)
library(readr)

ld_folder <- "..."
files <- list.files(ld_folder, pattern="\\.stat\\.gz$", full.names = TRUE)

groups <- sub("\\.stat\\.gz$", "", basename(files))

ld_list <- lapply(seq_along(files), function(i) {
  df <- read.table(files[i], header=TRUE)
  df$Group <- groups[i]
  return(df)
})

ld_data <- dplyr::bind_rows(ld_list)


ggplot(ld_data, aes(x=Dist, y=Mean_r2, color=Group)) +
  geom_line(size=1.2) +                 
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