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

png(file="C:/Users/kjlis/Desktop/fst_all.png", width=1000, height=950, res=150)
ggplot(fst_all, aes(x = Group, y = Fst)) +
  geom_boxplot(fill = "aquamarine3") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        axis.title.x = element_text(size = 14, margin = margin(t = 10)),
        axis.title.y = element_text(size = 14, margin = margin(r = 10)),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        plot.margin = margin(10, 10, 10, 10)) +
  labs(title = "fixation index between subpopulations",
       x = "subpopulation",
       y = "fst")
dev.off()



Pv_Tr_chr <- split(Pv_Tr_clean, Pv_Tr_clean$Chr)
Tr_Idt_1_chr <- split(Tr_Idt_1_clean, Tr_Idt_1_clean$Chr)
Tr_SS_1_chr <- split(Tr_SS_1_clean, Tr_SS_1_clean$Chr)
Idt_1vs2_chr <- split(Idt_1vs2_clean, Idt_1vs2_clean$Chr)
SS_1vs2_chr <- split(SS_1vs2_clean, SS_1vs2_clean$Chr)

library(GenWin)




################################

#rbind, boxplot, SS I vs. SS II, Iodent stary vs. Iodent nowy
#Tropical vs stary SS, tak samo Iodent

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



