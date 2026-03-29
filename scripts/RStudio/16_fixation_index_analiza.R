Pv_Tr <- read.table("C:/Users/kjlis/Desktop/Parviglumis_Tropical.fst", header=TRUE)
Tr_Idt_1 <- read.table("C:/Users/kjlis/Desktop/Tropical_Iodent_era1.fst", header=TRUE)
Tr_SS_1 <- read.table("C:/Users/kjlis/Desktop/Tropical_SS_era1.fst", header=TRUE)
Idt_1vs2 <- read.table("C:/Users/kjlis/Desktop/Iodent_era1_era2.fst", header=TRUE)
SS_1vs2 <- read.table("C:/Users/kjlis/Desktop/SS_era1_era2.fst", header=TRUE)

Pv_Tr$Fst <- pmax(Pv_Tr$Fst, 0)
Tr_Idt_1$Fst <- pmax(Tr_Idt_1$Fst, 0)
Tr_SS_1$Fst <- pmax(Tr_SS_1$Fst, 0)
Idt_1vs2$Fst <- pmax(Idt_1vs2$Fst, 0)
SS_1vs2$Fst <- pmax(SS_1vs2$Fst, 0)

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



fst_all <- rbind(
  data.frame(Group = "Parviglumis vs. Tropical", Fst = Pv_Tr_clean$Fst),
  data.frame(Group = "Tropical vs. Iodent era I", Fst = Tr_Idt_1_clean$Fst),
  data.frame(Group = "Tropical vs. SS era I", Fst = Tr_SS_1_clean$Fst),
  data.frame(Group = "Iodent era I vs. era II", Fst = Idt_1vs2_clean$Fst),
  data.frame(Group = "SS era I vs. era II", Fst = SS_1vs2_clean$Fst)
)

fst_all$Group <- factor(
  fst_all$Group,
  levels = c("Parviglumis vs. Tropical", "Tropical vs. Iodent era I", "Tropical vs. SS era I",
             "Iodent era I vs. era II", "SS era I vs. era II")
)

library(ggplot2)

png(file="C:/Users/kjlis/Desktop/fst_all.png", width=1000, height=1100, res=150)
ggplot(fst_all, aes(x = Group, y = Fst)) +
  geom_boxplot(fill = "aquamarine3") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        axis.title.x = element_text(size = 13, margin = margin(t = 12), face = "bold"),
        axis.title.y = element_text(size = 13, margin = margin(r = 12), face = "bold"),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 15, face = "bold", hjust = 0.5),
        plot.margin = margin(11, 11, 11, 11)) +
  labs(title = "fixation index between groups",
       x = "group",
       y = "fst")
dev.off()



Pv_Tr_chr1 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 1, ]
Pv_Tr_chr2 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 2, ]
Pv_Tr_chr3 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 3, ]
Pv_Tr_chr4 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 4, ]
Pv_Tr_chr5 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 5, ]
Pv_Tr_chr6 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 6, ]
Pv_Tr_chr7 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 7, ]
Pv_Tr_chr8 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 8, ]
Pv_Tr_chr9 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 9, ]
Pv_Tr_chr10 <- Pv_Tr_clean[Pv_Tr_clean$Chr == 10, ]

library(GenWin)

Pv_Tr_chr1_spline <- splineAnalyze(Y=Pv_Tr_chr1$Fst,map=Pv_Tr_chr1$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr2_spline <- splineAnalyze(Y=Pv_Tr_chr2$Fst,map=Pv_Tr_chr2$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr3_spline <- splineAnalyze(Y=Pv_Tr_chr3$Fst,map=Pv_Tr_chr3$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr4_spline <- splineAnalyze(Y=Pv_Tr_chr4$Fst,map=Pv_Tr_chr4$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr5_spline <- splineAnalyze(Y=Pv_Tr_chr5$Fst,map=Pv_Tr_chr5$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr6_spline <- splineAnalyze(Y=Pv_Tr_chr6$Fst,map=Pv_Tr_chr6$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr7_spline <- splineAnalyze(Y=Pv_Tr_chr7$Fst,map=Pv_Tr_chr7$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr8_spline <- splineAnalyze(Y=Pv_Tr_chr8$Fst,map=Pv_Tr_chr8$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr9_spline <- splineAnalyze(Y=Pv_Tr_chr9$Fst,map=Pv_Tr_chr9$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
Pv_Tr_chr10_spline <- splineAnalyze(Y=Pv_Tr_chr10$Fst,map=Pv_Tr_chr10$bp,smoothness=200,
                                   plotRaw=TRUE,plotWindows=TRUE,method=4)
