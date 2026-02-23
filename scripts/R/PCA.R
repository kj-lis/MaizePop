library(ggplot2)
library(dplyr)

pca <- read.table("/home/kuba/Desktop/full/chr_zea_mays_all_plink_PCA.eigenvec", header = FALSE)
pca2 <- read.table("/home/kuba/Desktop/full/chr_zea_mmp_all_plink_PCA.eigenvec", header = FALSE)

colnames(pca)[1:2] <- c("FID", "VCFname")
colnames(pca)[3:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-2))

colnames(pca2)[1:2] <- c("FID", "VCFname")
colnames(pca2)[3:ncol(pca2)] <- paste0("PC", 1:(ncol(pca2)-2))

metadane <- read.csv("/home/kuba/Desktop/zmays_metadane_PCA.csv", stringsAsFactors = FALSE)
metadane2 <- read.csv("/home/kuba/Desktop/zall_metadane_PCA.csv", stringsAsFactors = FALSE)

pca_meta <- left_join(pca, metadane, by = "VCFname")
pca_meta2 <- left_join(pca2, metadane2, by = "VCFname")


pca_meta$Poland_flag <- factor(ifelse(pca_meta$orygin == "Poland",
                                      "Poland",
                                      "Other"),
                               levels = c("Other", "Poland"))


ggplot(pca_meta, aes(x = PC1, y = PC2)) +
  
  geom_point(data = subset(pca_meta, Poland_flag == "Other"),
             aes(color = Q, shape = Poland_flag),
             size = 3,
             alpha = 0.1) +
  
  geom_point(data = subset(pca_meta, Poland_flag == "Poland"),
             aes(color = Q, shape = Poland_flag),
             size = 3) +
  
  scale_shape_manual(
    values = c("Other" = 16, "Poland" = 17),
    name = "Origin"
  ) +
  
  labs(color = "Group") +
  
  guides(
    color = guide_legend(override.aes = list(alpha = 1), order = 1),
    shape = guide_legend(order = 2)
  ) +
  
  theme_minimal()


#############################
  

ggplot(pca_meta, aes(x = PC1, y = PC2)) +
  
  geom_point(data = subset(pca_meta, Poland_flag == "Other"),
             aes(color = Q, shape = Poland_flag),
             size = 3,
             alpha = 0.1) +
  
  geom_point(data = subset(pca_meta, Poland_flag == "Poland"),
             aes(color = Q, shape = Poland_flag),
             size = 3) +
  
  scale_color_manual(
    values = c(
      "NSS"      = "#F8766D",
      "SS"       = "#00B0F6",
      "Iodent"   = "#00BF7D",
      "Mix"      = "#A3A500",
      "Tropical" = "#E76BF3"
    )
  ) +
  
  scale_shape_manual(
    values = c("Other" = 16, "Poland" = 17),
    name = "Origin"
  ) +
  
  labs(color = "Group") +
  
  guides(
    color = guide_legend(override.aes = list(alpha = 1), order = 1),
    shape = guide_legend(order = 2)
  ) +
  
  theme_minimal()



#############################
  

  
ggplot(pca_meta2, aes(x = PC1, y = PC2, color = Q)) +
  geom_point(size = 3) +
  labs(color = "Group") +
  theme_minimal()


#############################


ggplot(pca_meta2, aes(x = PC1, y = PC2, color = Q)) +
  geom_point(size = 3) +
  
  scale_color_manual(
    values = c(
      "NSS"          = "#F8766D",
      "SS"           = "#00B0F6",
      "Iodent"       = "#00BF7D",
      "Mix"          = "#A3A500",
      "Tropical"     = "#E76BF3",
      "Parviglumis"  = "#f09a4a",
      "Mexicana"     = "#12E9E3"
    )
  ) +
  
  labs(color = "Group") +
  theme_minimal()

