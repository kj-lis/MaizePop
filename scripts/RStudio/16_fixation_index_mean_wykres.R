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


fst <- read.table("/home/kuba/Desktop/Parviglumis_Tropical_fst.fst", header=TRUE)
head(fst)
str(fst)

hist(fst$Fst,
     breaks=100,
     col="steelblue",
     main="Distribution of FST",
     xlab="FST")

install.packages("qqman")
library(qqman)

fst2 <- fst
fst2 <- fst2[!is.na(fst2$Fst), ]
fst2$Fst[fst2$Fst < 0] <- 0

manhattan(fst2,
          chr="Chr",
          bp="bp",
          snp="SNP",
          p="Fst",
          logp=FALSE,
          col=c("darkblue","orange"),
          ylab="FST")