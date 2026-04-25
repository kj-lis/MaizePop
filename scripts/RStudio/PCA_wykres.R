################################


library(ggplot2)
library(dplyr)

pca <- read.table("C:/Users/kjlis/Desktop/chr_all_PCA.eigenvec", header = FALSE)
metadane <- read.csv("C:/Users/kjlis/Desktop/metadane_all.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Subpopulation"

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
  "Parviglumis",
  "Mexicana")

group_colors <- c(
  "Iodent"      = "green3",
  "SS"          = "blue",
  "NSS"         = "red3",
  "Tropical"    = "purple",
  "Mix"         = "gold",
  "Parviglumis" = "cyan3",
  "Mexicana"    = "darkorange")

png(file="C:/Users/kjlis/Desktop/PCA_1v2.png", width=2000, height=1800, res=250)
ggplot(pca_metadane, aes(x = PC1, y = PC2, color = heterotic.group)) +
  
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
    
    axis.title.x = element_text(
      size = axis_title_size,
      margin = margin(t = 13),
      face = "bold"),
      
    
    axis.title.y = element_text(
      size = axis_title_size,
      margin = margin(r = 13),
      face = "bold"),
      
    
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
dev.off()


################################


library(ggplot2)
library(dplyr)

pca <- read.table("C:/Users/kjlis/Desktop/chr_all_PCA.eigenvec", header = FALSE)
metadane <- read.csv("C:/Users/kjlis/Desktop/metadane_all.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Subpopulation"

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
  "Parviglumis",
  "Mexicana"
)

group_colors <- c(
  "Iodent"      = "green3",
  "SS"          = "blue",
  "NSS"         = "red3",
  "Tropical"    = "purple",
  "Mix"         = "gold",
  "Parviglumis" = "cyan3",
  "Mexicana"    = "darkorange"
)

pca_metadane <- pca_metadane %>%
  mutate(
    origin_group = ifelse(is.na(origin) | origin != "Poland", "Other", "Poland")
  )

png(file = "C:/Users/kjlis/Desktop/PCA_2v3_origin.png", width = 2000, height = 1800, res = 250)
ggplot(pca_metadane, aes(x = PC2, y = PC3, color = heterotic.group)) +
  
  geom_point(
    data = subset(pca_metadane, origin_group == "Other"),
    size = point_size,
    alpha = 0.08
  ) +
  
  geom_point(
    data = subset(pca_metadane, origin_group == "Poland"),
    size = point_size,
    alpha = 1
  ) +
  
  scale_color_manual(
    name = legend_title,
    values = group_colors,
    breaks = legend_order
  ) +
  
  labs(
    x = "PC2",
    y = "PC3"
  ) +
  
  theme_classic() +
  
  theme(
    axis.title.x = element_text(
      size = axis_title_size,
      margin = margin(t = 13),
      face = "bold"
    ),
    axis.title.y = element_text(
      size = axis_title_size,
      margin = margin(r = 13),
      face = "bold"
    ),
    
    axis.text = element_text(size = axis_text_size),
    
    legend.position = "right",
    legend.title = element_text(size = legend_title_size, face = "bold"),
    legend.text = element_text(size = legend_text_size),
    legend.key.size = unit(1, "cm")
  ) +
  
  guides(
    color = guide_legend(
      override.aes = list(size = legend_point_size, alpha = 1)
    )
  )

dev.off()


################################


library(ggplot2)
library(dplyr)

pca <- read.table("C:/Users/kjlis/Desktop/chr_all_PCA.eigenvec", header = FALSE)
metadane <- read.csv("C:/Users/kjlis/Desktop/metadane_final.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Subpopulation"
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
  "Parviglumis",
  "Mexicana")

group_colors <- c(
  "Iodent"      = "green3",
  "SS"          = "blue",
  "NSS"         = "red3",
  "Tropical"    = "purple",
  "Mix"         = "gold",
  "Parviglumis" = "cyan3",
  "Mexicana"    = "darkorange")

shape_values <- c(
  "Other" = 16,
  "Poland" = 8)

alpha_other <- 0.7
alpha_poland <- 1

pca_metadane <- pca_metadane %>%
  mutate(
    origin_group = ifelse(is.na(meta_original) | meta_original != "Poland", "Other", "Poland"),
    point_alpha = ifelse(origin_group == "Poland", alpha_poland, alpha_other))

png(file="C:/Users/kjlis/Desktop/PCA_2v3_origin.png", width=1800, height=1400, res=250)
ggplot(
  pca_metadane,
  aes(x = PC2, y = PC3, color = population, shape = origin_group, alpha = point_alpha)) +
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
    
    legend.position = "right",
    legend.title = element_text(size = legend_title_size, face = "bold"),
    legend.text = element_text(size = legend_text_size),
    legend.key.size = unit(1, "cm")) +
  
  guides(
    color = guide_legend(override.aes = list(size = legend_point_size, alpha = 1)),
    shape = guide_legend(override.aes = list(size = legend_point_size, color = "black", alpha = 1)))
dev.off()


################################


library(ggplot2)
library(dplyr)

pca <- read.table("C:/Users/kjlis/Desktop/chr_all_PCA.eigenvec", header = FALSE)
metadane <- read.csv("C:/Users/kjlis/Desktop/metadane_final.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "Subpopulation"
shape_legend_title <- "Era"

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
  "Parviglumis",
  "Mexicana")

group_colors <- c(
  "Iodent"      = "green3",
  "SS"          = "blue",
  "NSS"         = "red3",
  "Tropical"    = "purple",
  "Mix"         = "gold",
  "Parviglumis" = "cyan3",
  "Mexicana"    = "darkorange")

shape_values <- c(
  "Era I" = 6,
  "Era II" = 5,
  "Other" = 16
)

guides(
  color = guide_legend(order = 1),
  shape = guide_legend(order = 2)
)

pca_metadane <- pca_metadane %>%
  mutate(era_shape = case_when(
      era_2 == "I"  ~ "Era I",
      era_2 == "II" ~ "Era II",
      TRUE          ~ "Other"
    )
  )

png(file="C:/Users/kjlis/Desktop/PCA_1v2_era.png", width=1800, height=1400, res=250)
ggplot(
  pca_metadane,
  aes(x = PC1, y = PC2, color = population, shape = era_shape, alpha = point_alpha)) +
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
    
    axis.title.x = element_text(size = axis_title_size, margin = margin(t = 13)),
    axis.title.y = element_text(size = axis_title_size, margin = margin(r = 13)),
    
    axis.text = element_text(size = axis_text_size),
    
    legend.position = "right",
    legend.title = element_text(size = legend_title_size, face = "bold"),
    legend.text = element_text(size = legend_text_size),
    legend.key.size = unit(1, "cm")) +
  
  guides(
    color = guide_legend(order = 1, override.aes = list(size = legend_point_size, alpha = 1)),
    shape = guide_legend(order = 2, override.aes = list(size = legend_point_size, color = "black", alpha = 1)))
dev.off()

################################


library(ggplot2)
library(dplyr)

pca <- read.table("C:/Users/kjlis/Desktop/chr_all_PCA.eigenvec", header = FALSE)
metadane <- read.csv("C:/Users/kjlis/Desktop/metadane_final.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

pca_metadane <- pca_metadane %>%
  mutate(
    origin_group = ifelse(is.na(meta_original) | meta_original != "Poland", "Other", "Poland"),
    
    era_shape = case_when(
      era_2 == "I"  ~ "Era I",
      era_2 == "II" ~ "Era II",
      TRUE          ~ "Other"
    )
  )

shape_values <- c(
  "Era I" = 23,
  "Era II" = 22,
  "Other" = 21)

legend_title_fill <- "Subpopulation" 
legend_title_shape <- "Era" 
legend_title_color <- "Origin"

guides(
  color = guide_legend(order = 2),
  shape = guide_legend(order = 3),
  fill = guide_legend(order = 1)
)

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
  "Parviglumis",
  "Mexicana")

group_colors <- c(
  "Iodent"      = "green3",
  "SS"          = "blue",
  "NSS"         = "red3",
  "Tropical"    = "purple",
  "Mix"         = "gold",
  "Parviglumis" = "cyan3",
  "Mexicana"    = "darkorange")

png(file="C:/Users/kjlis/Desktop/PCA_all_2v3.png",
    width=2000, height=1800, res=250)

ggplot(
  pca_metadane,
  aes(
    x = PC2,
    y = PC3,
    fill = population,
    shape = era_shape,
    color = origin_group
  )
) +
  geom_point(size = point_size, stroke = 1) +
  
  scale_fill_manual(
    name = legend_title_fill,
    values = group_colors,
    breaks = legend_order
  ) +
  
  scale_shape_manual(
    name = legend_title_shape,
    values = shape_values
  ) +
  
  scale_color_manual(
    name = legend_title_color,
    values = c("Poland" = "black", "Other" = "grey60"),
    breaks = c("Poland", "Other") 
  ) +
  
  labs(
    x = "PC2",
    y = "PC3"
  ) +
  
  theme_classic() +
  
  theme(
    axis.title.x = element_text(size = axis_title_size, margin = margin(t = 13)),
    axis.title.y = element_text(size = axis_title_size, margin = margin(r = 13)),
    axis.text = element_text(size = axis_text_size),
    legend.position = "right",
    legend.title = element_text(size = legend_title_size, face = "bold"),
    legend.text = element_text(size = legend_text_size),
    legend.key.size = unit(1, "cm")
  ) +
  
  guides(
    fill = guide_legend(
      order = 1,
      override.aes = list(
        shape = 21,
        color = NA,                
        size = legend_point_size
      )
    ),
    
    shape = guide_legend(
      order = 2,
      override.aes = list(
        size = legend_point_size
      )
    ),
    
    color = guide_legend(
      order = 3,
      override.aes = list(
        shape = 21,               
        fill = "white",             
        size = legend_point_size,
        stroke = 1.2                
      )
    )
  )

dev.off()