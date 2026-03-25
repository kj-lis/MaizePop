PT_fst <- read.table("/home/kuba/Desktop/Parviglumis_Tropical.fst", header=TRUE)
TI_fst <- read.table("/home/kuba/Desktop/Tropical_Iodent.fst", header=TRUE)
TSS_fst <- read.table("/home/kuba/Desktop/Tropical_SS.fst", header=TRUE)
TNS_fst <- read.table("/home/kuba/Desktop/Tropical_NSS.fst", header=TRUE)

PT_fst_clean <- PT_fst[!is.na(PT_fst$Fst), ]
TI_fst_clean <- TI_fst[!is.na(TI_fst$Fst), ]
TSS_fst_clean <- TSS_fst[!is.na(TSS_fst$Fst), ]
TNS_fst_clean <- TNS_fst[!is.na(TNS_fst$Fst), ]

summary(PT_fst_clean$Fst)
summary(TI_fst_clean$FST)
summary(TSS_fst_clean$FST)
summary(TNS_fst_clean$FST)

library(ggplot2)

ggplot(PT_fst_clean, aes(x = Fst)) +
  geom_histogram(bins = 100, fill = "steelblue", color = "black") +
  theme_minimal() + 
  theme(panel.grid = element_blank()) +
  labs(
    x = "fixation index",
    y = "number of SNPs")

PT_fst_chr1 <- PT_fst_clean[PT_fst_clean$Chr == 1, ]
PT_fst_chr2 <- PT_fst_clean[PT_fst_clean$Chr == 2, ]
PT_fst_chr3 <- PT_fst_clean[PT_fst_clean$Chr == 3, ]
PT_fst_chr4 <- PT_fst_clean[PT_fst_clean$Chr == 4, ]
PT_fst_chr5 <- PT_fst_clean[PT_fst_clean$Chr == 5, ]
PT_fst_chr6 <- PT_fst_clean[PT_fst_clean$Chr == 6, ]
PT_fst_chr7 <- PT_fst_clean[PT_fst_clean$Chr == 7, ]
PT_fst_chr8 <- PT_fst_clean[PT_fst_clean$Chr == 8, ]
PT_fst_chr9 <- PT_fst_clean[PT_fst_clean$Chr == 9, ]
PT_fst_chr10 <- PT_fst_clean[PT_fst_clean$Chr == 10, ]

chr10_subset <- subset(PT_fst_chr10, bp >= 2e7 & bp <= 3e7)

library(GenWin)

PT_fst_chr10_spline <- splineAnalyze(Y=chr10_subset$Fst,map=chr10_subset$bp,smoothness=300,
                                     plotRaw=TRUE,plotWindows=TRUE,method=4)




################################




fst_data <- read.table("fst_results.txt", header=TRUE) 
head(fst_data)

mean_fst <- mean(fst_data$FST, na.rm = TRUE)
mean_fst

hist(fst_data$FST,
     breaks = 50,
     col = "skyblue",
     main = "FST: Parviglumis vs. Iodent",
     xlab = "FST",
     ylab = "Number of SNPs")

abline(v = mean_fst, col = "red", lwd = 2)
text(mean_fst, par("usr")[4]*0.9, labels = paste0("Mean = ", round(mean_fst,3)),
     col="red", pos=4)

boxplot(fst_data$FST,
        horizontal = TRUE,
        col = "lightgreen",
        main = "FST: Parviglumis vs. Iodent",
        xlab = "FST")

points(mean_fst, 1, col = "red", pch = 19)




library(dplyr)
fst_by_chr <- TI_fst %>%
  group_by(Chr) %>%
  summarise(mean_fst = mean(Fst, na.rm=TRUE))

barplot(fst_by_chr$mean_fst,
        names.arg = fst_by_chr$Chr,
        col = "steelblue",
        xlab = "Chromosome",
        ylab = "Mean FST",
        main = "Mean FST per chromosome")
mean_fst <- mean(TI_fst_clean$Fst, na.rm = TRUE)

plot(density(TI_fst_clean$Fst, na.rm=TRUE),
     main="Density of FST",
     xlab="FST",
     ylab="Density",
     col="blue", lwd=2)
abline(v = mean_fst, col="red", lwd=2)






fst1<- read.table("/home/kuba/Desktop/Parviglumis_Tropical.fst", header=TRUE)
fst2<- read.table("/home/kuba/Desktop/Tropical_Iodent.fst", header=TRUE)
fst3<- read.table("/home/kuba/Desktop/Tropical_SS.fst", header=TRUE)
fst4<- read.table("/home/kuba/Desktop/Tropical_NSS.fst", header=TRUE)

head(fst2)
str(fst2)

hist(PT_fst$Fst,
     breaks=100,
     col="steelblue",
     main="Distribution of FST",
     xlab="FST")

install.packages("qqman")
library(qqman)

fst1_2 <- fst1
fst1_2 <- fst1_2[!is.na(fst1_2$Fst), ]
fst1_2$Fst[fst1_2$Fst < 0] <- 0

manhattan(fst1_2,
          chr="Chr",
          bp="bp",
          snp="SNP",
          p="Fst",
          logp=FALSE,
          col=c("darkblue","orange"),
          ylab="FST")


PT_fst_2 <- PT_fst[PT_fst$Fst >= 0, ]
TI_fst_2 <- TI_fst[TI_fst$Fst >= 0, ]
TSS_fst_2 <- TSS_fst[TSS_fst$Fst >= 0, ]
TNS_fst_2 <- TNS_fst[TNS_fst$Fst >= 0, ]