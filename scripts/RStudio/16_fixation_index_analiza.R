Pv_Tr <- read.table("C:/Users/kjlis/Desktop/Parviglumis_Tropical.fst", header=TRUE)
Tr_Idt_1 <- read.table("C:/Users/kjlis/Desktop/Tropical_Iodent_era1.fst", header=TRUE)
Tr_SS_1 <- read.table("C:/Users/kjlis/Desktop/Tropical_SS_era1.fst", header=TRUE)
Idt_1vs2 <- read.table("C:/Users/kjlis/Desktop/Iodent_era1_era2.fst", header=TRUE)
SS_1vs2 <- read.table("C:/Users/kjlis/Desktop/SS_era1_era2.fst", header=TRUE)

Pv_Tr <- pmax(Pv_Tr$Fst, 0)
Tr_Idt_1 <- pmax(Tr_Idt_1$Fst, 0)
Tr_SS_1 <- pmax(Tr_SS_1$Fst, 0)
Idt_1vs2 <- pmax(Idt_1vs2$Fst, 0)
SS_1vs2 <- pmax(SS_1vs2$Fst, 0)

Pv_Tr_clean <- Pv_Tr[!is.na(Pv_Tr$Fst), ]
Tr_Idt_1_clean <- Tr_Idt_1[!is.na(Tr_Idt_1$Fst), ]
Tr_SS_1_clean <- Tr_SS_1[!is.na(Tr_SS_1$Fst), ]
Idt_1vs2_clean <- Idt_1vs2[!is.na(Idt_1vs2$Fst), ]
SS_1vs2_clean <- SS_1vs2[!is.na(SS_1vs2$Fst), ]

summary(Pv_Tr_clean$Fst)
summary(Tr_Idt_1_clean$Fst)
summary(Tr_SS_1_clean$Fst)
summary(Idt_1vs2_clean$Fst)
summary(SS_1vs2_clean$Fst)








#rbind, boxplot, SS I vs. SS II, Iodent stary vs. Iodent nowy
#Tropical vs stary SS, tak samo Iodent

PT$Fst <- pmax(PT$Fst, 0)
TI$Fst <- pmax(TI$Fst, 0)
TSS$Fst <- pmax(TSS$Fst, 0)
TNS$Fst <- pmax(TNS$Fst, 0)

PT_clean <- PT[!is.na(PT$Fst), ]
TI_clean <- TI[!is.na(TI$Fst), ]
TSS_clean <- TSS[!is.na(TSS$Fst), ]
TNS_clean <- TNS[!is.na(TNS$Fst), ]

summary(PT_clean$Fst)
summary(TI_clean$FST)
summary(TSS_clean$FST)
summary(TNS_clean$FST)

library(ggplot2)

ggplot(PT_clean, aes(x = Fst)) +
  geom_histogram(bins = 50, fill = "steelblue", color = "black") +
  coord_cartesian(ylim = c(0, 4000000)) +
  theme_minimal() + 
  theme(panel.grid = element_blank()) +
  labs(
    x = "fixation index",
    y = "number of SNPs")

PT_chr1 <- PT_clean[PT_clean$Chr == 1, ]
PT_chr2 <- PT_clean[PT_clean$Chr == 2, ]
PT_chr3 <- PT_clean[PT_clean$Chr == 3, ]
PT_chr4 <- PT_clean[PT_clean$Chr == 4, ]
PT_chr5 <- PT_clean[PT_clean$Chr == 5, ]
PT_chr6 <- PT_clean[PT_clean$Chr == 6, ]
PT_chr7 <- PT_clean[PT_clean$Chr == 7, ]
PT_chr8 <- PT_clean[PT_clean$Chr == 8, ]
PT_chr9 <- PT_clean[PT_clean$Chr == 9, ]
PT_chr10 <- PT_clean[PT_clean$Chr == 10, ]

library(GenWin)

PT_chr4_spline <- splineAnalyze(Y=chr4_subset$Fst,map=chr4_subset$bp,smoothness=300,
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

boxplot(PT_clean$Fst,
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

plot(density(PT_clean$Fst),
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