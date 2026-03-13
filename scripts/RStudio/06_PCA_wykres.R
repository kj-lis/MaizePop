library(ggplot2)
library(dplyr)

pca <- read.table("/home/kuba/Desktop/chr_all_zmays_PCA.eigenvec", header = FALSE)
metadane <- read.csv("/home/kuba/Desktop/zea_all_admix.csv", stringsAsFactors = FALSE, sep = ";")

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
  "Mix"         = "#A3A500")

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




################################




library(ggplot2)
library(dplyr)

pca <- read.table("/home/kuba/Desktop/chr_all_zea_PCA.eigenvec", header = FALSE)
metadane <- read.csv("/home/kuba/Desktop/zea_all_admix.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Heterotic group"

axis_title_size <- 14
axis_text_size <- 12

legend_title_size <- 14
legend_text_size <- 12

legend_point_size <- 3
point_size <- 2.5

font_family <- "Helvetica"

legend_order <- c(
  "Iodent",
  "SS",
  "NSS",
  "Tropical",
  "Mix",
  "Parviglumis",
  "Mexicana")

group_colors <- c(
  "Iodent"      = "#00BF7D",
  "SS"          = "#00B0F6",
  "NSS"         = "#F8766D",
  "Tropical"    = "#E76BF3",
  "Mix"         = "#A3A500",
  "Parviglumis" = "#12E9E3",
  "Mexicana"    = "#f09a4a")

p <- ggplot(pca_metadane, aes(x = PC2, y = PC3, color = heterotic_final)) +
  
  geom_point(size = point_size) +
  
  scale_color_manual(
    name = legend_title,
    values = group_colors,
    breaks = legend_order) +
  
  labs(
    x = "PC2",
    y = "PC3") +
  
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




################################




library(ggplot2)
library(dplyr)

pca <- read.table("/home/kuba/Desktop/chr_all_zmays_PCA.eigenvec", header = FALSE)
metadane <- read.csv("/home/kuba/Desktop/zea_all_admix.csv", stringsAsFactors = FALSE, sep = ",")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Group"
shape_legend_title <- "Origin"

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
  "Iodent"   = "#00BF7D",
  "SS"       = "#00B0F6",
  "NSS"      = "#F8766D",
  "Tropical" = "#E76BF3",
  "Mix"      = "#A3A500")

shape_values <- c(
  "Other" = 16,
  "Poland" = 3)

alpha_other <- 0.3
alpha_poland <- 1

pca_metadane <- pca_metadane %>%
  mutate(
    origin_group = ifelse(is.na(origin) | origin != "Poland", "Other", "Poland"),
    point_alpha = ifelse(origin_group == "Poland", alpha_poland, alpha_other))

p <- ggplot(
  pca_metadane,
  aes(x = PC1, y = PC2, color = Q, shape = origin_group, alpha = point_alpha)) +
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
    x = "PC1",
    y = "PC2") +
  
  theme_classic() +
  
  theme(
    text = element_text(family = font_family),
    
    axis.title.x = element_text(size = axis_title_size, margin = margin(t = 13)),
    axis.title.y = element_text(size = axis_title_size, margin = margin(r = 13)),
    
    axis.text = element_text(size = axis_text_size),
    
    legend.position = "right",
    legend.title = element_text(size = legend_title_size, face = "bold"),
    legend.text = element_text(size = legend_text_size),
    legend.key.size = unit(1, "cm")) +
  
  guides(
    color = guide_legend(override.aes = list(size = legend_point_size, alpha = 1)),
    shape = guide_legend(override.aes = list(size = legend_point_size, color = "black", alpha = 1)))

p




################################




library(ggplot2)
library(dplyr)

pca <- read.table("/home/kuba/Desktop/chr_all_zea_PCA.eigenvec", header = FALSE)
metadane <- read.csv("/home/kuba/Desktop/zea_all_admix.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Heterotic group"
shape_legend_title <- "Origin"

axis_title_size <- 14
axis_text_size <- 12

legend_title_size <- 14
legend_text_size <- 12

legend_point_size <- 3
point_size <- 2.5

font_family <- "Helvetica"

legend_order <- c(
  "Iodent",
  "SS",
  "NSS",
  "Tropical",
  "Mix",
  "Mexicana",
  "Parviglumis")

group_colors <- c(
  "Iodent"      = "#00BF7D",
  "SS"          = "#00B0F6",
  "NSS"         = "#F8766D",
  "Tropical"    = "#E76BF3",
  "Mix"         = "#A3A500",
  "Mexicana"    = "#f09a4a",
  "Parviglumis" = "#12E9E3")

shape_values <- c(
  "Other" = 16,
  "Poland" = 8)

alpha_other <- 0.3
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
    text = element_text(family = font_family),
    
    axis.title.x = element_text(size = axis_title_size, margin = margin(t = 13)),
    axis.title.y = element_text(size = axis_title_size, margin = margin(r = 13)),
    
    axis.text = element_text(size = axis_text_size),
    
    legend.position = "right",
    legend.title = element_text(size = legend_title_size, face = "bold"),
    legend.text = element_text(size = legend_text_size),
    legend.key.size = unit(1, "cm")) +
  
  guides(
    color = guide_legend(override.aes = list(size = legend_point_size, alpha = 1)),
    shape = guide_legend(override.aes = list(size = legend_point_size, color = "black", alpha = 1)))

p


