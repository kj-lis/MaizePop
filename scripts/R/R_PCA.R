library(ggplot2)
library(dplyr)

pca <- read.table("/home/kuba/Desktop/full/chr_zea_mays_all_plink_PCA.eigenvec", header = FALSE)

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

metadane <- read.csv("/home/kuba/Desktop/zmays_metadane_PCA.csv", stringsAsFactors = FALSE)

pca_meta <- left_join(pca, metadane, by = "VCFname")

ggplot(pca_meta, aes(x = PC1, y = PC2)) +
  geom_point(data = subset(pca_meta, orygin != "Poland"),
             aes(color = Q),
             size = 3,
             alpha = 0.1,
             shape = 16) +
  
  geom_point(data = subset(pca_meta, orygin == "Poland"),
             aes(color = Q),
             size = 3,
             shape = 17) +
  
  labs(color = "Group") +
  theme_minimal()

