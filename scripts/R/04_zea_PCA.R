library(ggplot2)
library(dplyr)

pca <- read.table("/home/kuba/Desktop/full/zea_mays/chr_zea_mays_all_plink_PCA.eigenvec", header = FALSE)

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

metadane <- read.csv("/home/kuba/Desktop/zea_all_metadane.csv", stringsAsFactors = FALSE)

pca_meta <- left_join(pca, metadane, by = "VCFname")

pca_meta$Poland_flag <- factor(ifelse(pca_meta$origin == "Poland",
                                      "Poland",
                                      "Other"),
                               levels = c("Other", "Poland"))


pca_meta$Q <- factor(
  pca_meta$Q,
  levels = c("Iodent", "SS", "NSS", "Tropical", "Mix", "Parviglumis", "Mexicana")
)

color_values <- c(
  "Iodent"      = "#00BF7D",
  "SS"          = "#00B0F6",
  "NSS"         = "#F8766D",
  "Tropical"    = "#E76BF3",
  "Mix"         = "#A3A500",
  "Parviglumis" = "#f09a4a",
  "Mexicana"    = "#12E9E3"
)

color_labels <- c(
  "Iodent"      = "Iodent",
  "SS"          = "SS",
  "NSS"         = "NSS",
  "Tropical"    = "Tropical",
  "Mix"         = "Mix",
  "Parviglumis" = "Z. mays subsp. parviglumis",
  "Mexicana"    = "Z. mays subsp. mexicana"
)

legend_text_size  <- 12   
legend_title_size <- 14   
axis_text_size    <- 12   
axis_title_size   <- 14 

x_title_margin <- 15
y_title_margin <- 15

ggplot(pca_meta, aes(x = PC1, y = PC2)) +
  
  geom_point(
    data = subset(pca_meta, Poland_flag == "Other"),
    aes(color = Q, shape = Poland_flag),
    size = 3,
    alpha = 1
  ) +
  
  geom_point(
    data = subset(pca_meta, Poland_flag == "Poland"),
    aes(color = Q, shape = Poland_flag),
    size = 3,
    alpha = 1
  ) +
  
  scale_color_manual(values = color_values,
                     labels = color_labels,
                     drop = FALSE) +
  scale_shape_manual(values = c("Other" = 16, "Poland" = 16), name = "Origin") +
  labs(color = "Group",
       x = "PC1",
       y = "PC2") +
  guides(
    color = guide_legend(override.aes = list(alpha = 1), order = 1),
    shape = "none"
  ) +
  theme_minimal() +
  theme(
    panel.border = element_rect(colour = "black", fill = NA, size = 1),
    legend.position = "right",
    
    legend.text  = element_text(size = legend_text_size),
    legend.title = element_text(size = legend_title_size, face = "bold"),
    
    axis.text  = element_text(size = axis_text_size),
    
    axis.title.x = element_text(
      size = axis_title_size,
      margin = margin(t = x_title_margin)
    ),
    
    axis.title.y = element_text(
      size = axis_title_size,
      margin = margin(r = y_title_margin)
    ),
    
    plot.title = element_text(hjust = 0.5, face = "bold")
  )