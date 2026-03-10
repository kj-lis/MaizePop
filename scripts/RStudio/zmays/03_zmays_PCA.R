library(ggplot2)
library(dplyr)

pca <- read.table("/home/kuba/Desktop/chr_all_zmays_PCA.eigenvec", header = FALSE)
metadane <- read.csv("/home/kuba/Desktop/zmays_uniq.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Group"

axis_title_size <- 14
axis_text_size <- 12

legend_title_size <- 15
legend_text_size <- 12

legend_point_size <- 3
point_size <- 2.5

font_family <- "Helvetica"

legend_order <- c(
  "Iodent",
  "SS",
  "NSS",
  "Tropical",
  "Mix")

group_colors <- c(
  "Iodent"      = "#00BF7D",
  "SS"          = "#00B0F6",
  "NSS"         = "#F8766D",
  "Tropical"    = "#E76BF3",
  "Mix"         = "#f09a4a")

p <- ggplot(pca_metadane, aes(x = PC1, y = PC2, color = Q)) +
  
  geom_point(size = point_size) +
  
  scale_color_manual(
    name = legend_title,
    values = group_colors,
    breaks = legend_order) +
  
  labs(
    x = "PC1",
    y = "PC2") +
  
  theme_classic() +
  
  theme(
    
    text = element_text(family = font_family),
    
    axis.title.x = element_text(
      size = axis_title_size,
      margin = margin(t = 13)),
    
    axis.title.y = element_text(
      size = axis_title_size,
      margin = margin(r = 13)),
    
    axis.text = element_text(size = axis_text_size),
    
    legend.position = "right",
    
    legend.title = element_text(
      size = legend_title_size,
      face = "bold"),
    
    legend.text = element_text(
      size = legend_text_size),
    
    legend.key.size = unit(1, "cm")) +
  
  guides(
    color = guide_legend(
      override.aes = list(size = legend_point_size)))

p