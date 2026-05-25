################################


library(ggplot2)
library(dplyr)

pca <- read.table("C:/Users/kjlis/Desktop/chr_all_PCA.eigenvec", header = FALSE)
metadane <- read.csv("C:/Users/kjlis/Desktop/metadane_all.csv", stringsAsFactors = FALSE, sep = ";")

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

pca_metadane <- left_join(pca, metadane, by = "VCFname")

legend_title <- "subpopulation"

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

png(file="C:/Users/kjlis/Desktop/PCA_2v3.png", width=2000, height=1800, res=250)
ggplot(pca_metadane, aes(x = PC2, y = PC3, color = heterotic.group)) +
  
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

legend_title <- "subpopulation"

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

