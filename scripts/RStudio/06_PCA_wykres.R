library(ggplot2)
library(dplyr)

pca <- read.table("C:/Users/kjlis/Desktop/all_SNP_PCA.eigenvec", header = FALSE)
metadane <- read.csv("C:/Users/kjlis/Desktop/zea_all_admix.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Heterotic group"

axis_title_size <- 14
axis_text_size <- 14

legend_title_size <- 14
legend_text_size <- 14

legend_point_size <- 4
point_size <- 2.8

font_family <- "Helvetica"

legend_order <- c(
  "Iodent",
  "SS",
  "NSS",
  "Tropical",
  "Mix",
  "Zea mays subsp. parviglumis",
  "Zea mays subsp. mexicana")

group_colors <- c(
  "Iodent"      = "#00BF7D",
  "SS"          = "#00B0F6",
  "NSS"         = "#F8766D",
  "Tropical"    = "#E76BF3",
  "Mix"         = "#A3A500",
  "Zea mays subsp. parviglumis" = "#12E9E3",
  "Zea mays subsp. mexicana"    = "#f09a4a")

p <- ggplot(pca_metadane, aes(x = PC1, y = PC2, color = heterotic_final)) +
  
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

p_no_legend <- p + theme(legend.position = "none")
p_no_legend




################################




library(ggplot2)
library(dplyr)

pca <- read.table("C:/Users/kjlis/Desktop/all_SNP_PCA.eigenvec", header = FALSE)
metadane <- read.csv("C:/Users/kjlis/Desktop/zea_all_admix.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Heterotic group"
shape_legend_title <- "Origin"

axis_title_size <- 14
axis_text_size <- 14

legend_title_size <- 14
legend_text_size <- 14

legend_point_size <- 4
point_size <- 2.8

legend_order <- c(
  "Iodent",
  "SS",
  "NSS",
  "Tropical",
  "Mix",
  "Zea mays subsp. parviglumis",
  "Zea mays subsp. mexicana")

group_colors <- c(
  "Iodent"      = "#00BF7D",
  "SS"          = "#00B0F6",
  "NSS"         = "#F8766D",
  "Tropical"    = "#E76BF3",
  "Mix"         = "#A3A500",
  "Zea mays subsp. parviglumis" = "#12E9E3",
  "Zea mays subsp. mexicana"    = "#f09a4a")

shape_values <- c(
  "Other" = 16,
  "Poland" = 8)

alpha_other <- 0.7
alpha_poland <- 1

pca_metadane <- pca_metadane %>%
  mutate(
    origin_group = ifelse(is.na(origin) | origin != "Poland", "Other", "Poland"),
    point_alpha = ifelse(origin_group == "Poland", alpha_poland, alpha_other))

p <- ggplot(
  pca_metadane,
  aes(x = PC2, y = PC3, color = heterotic_final, shape = origin_group, alpha = point_alpha)) +
  geom_point(size = point_size) +
  
  scale_color_manual(
    name = legend_title,
    values = group_colors,
    breaks = legend_order) +
  
  scale_shape_manual(
    name = shape_legend_title,
    values = shape_values) +
  
  scale_alpha_identity() +  
  
  labs(
    x = "PC2",
    y = "PC3") +
  
  theme_classic() +
  
  theme(
    
    axis.title.x = element_text(size = axis_title_size, margin = margin(t = 13)),
    axis.title.y = element_text(size = axis_title_size, margin = margin(r = 13)),
    
    axis.text = element_text(size = axis_text_size),
    
    legend.position = "top",
    legend.title = element_text(size = legend_title_size, face = "bold"),
    legend.text = element_text(size = legend_text_size),
    legend.key.size = unit(1, "cm")) +
  
  guides(
    color = guide_legend(override.aes = list(size = legend_point_size, alpha = 1)),
    shape = guide_legend(override.aes = list(size = legend_point_size, color = "black", alpha = 1)))

p

p_no_legend <- p + theme(legend.position = "none")
p_no_legend




################################




library(cowplot)

legend <- get_legend(p)

legend

plot_grid(legend)