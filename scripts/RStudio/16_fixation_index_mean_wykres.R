PT_fst <- read.table("/home/kuba/Desktop/Parviglumis_Tropical.fst", header=TRUE)
TI_fst <- read.table("/home/kuba/Desktop/Tropical_Iodent.fst", header=TRUE)
TSS_fst <- read.table("/home/kuba/Desktop/Tropical_SS.fst", header=TRUE)
TNS_fst <- read.table("/home/kuba/Desktop/Tropical_NSS.fst", header=TRUE)

summary(PT_fst$Fst)
summary(TI_fst$FST)
summary(TSS_fst$FST)
summary(TNS_fst$FST)

PT_fst_mean <- mean(PT_fst$Fst, na.rm=TRUE)
TI_fst_mean <- mean(TI_fst$Fst, na.rm=TRUE)
TSS_fst_mean <- mean(TSS_fst$Fst, na.rm=TRUE)
TNS_fst_mean <- mean(TNS_fst$Fst, na.rm=TRUE)

ggplot(df, aes(x = FST)) +
  geom_histogram(bins = 50, fill = "steelblue", color = "black") +
  theme_minimal() +
  labs(
    title = "Rozkład FST",
    x = "FST",
    y = "Liczba SNP"
  )

















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
fst_by_chr <- fst_data %>%
  group_by(CHR) %>%
  summarise(mean_FST = mean(FST, na.rm=TRUE))

barplot(fst_by_chr$mean_FST,
        names.arg = fst_by_chr$CHR,
        col = "steelblue",
        xlab = "Chromosome",
        ylab = "Mean FST",
        main = "Mean FST per chromosome")

plot(density(fst_data$FST, na.rm=TRUE),
     main="Density of FST",
     xlab="FST",
     ylab="Density",
     col="blue", lwd=2)
abline(v = mean_fst, col="red", lwd=2)












################################


fst1<- read.table("/home/kuba/Desktop/Parviglumis_Tropical.fst", header=TRUE)
fst2<- read.table("/home/kuba/Desktop/Tropical_Iodent.fst", header=TRUE)
fst3<- read.table("/home/kuba/Desktop/Tropical_SS.fst", header=TRUE)
fst4<- read.table("/home/kuba/Desktop/Tropical_NSS.fst", header=TRUE)

head(fst2)
str(fst2)

hist(fst4$Fst,
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