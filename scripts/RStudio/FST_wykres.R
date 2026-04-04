################################


Mx_Pv <- read.table("/home/kuba/Desktop/Mexicana_Parviglumis.fst", header=TRUE)
Pv_Tr <- read.table("/home/kuba/Desktop/Parviglumis_Tropical.fst", header=TRUE)
Tr_Idt_1 <- read.table("/home/kuba/Desktop/Tropical_Iodent_era1.fst", header=TRUE)
Tr_SS_1 <- read.table("/home/kuba/Desktop/Tropical_SS_era1.fst", header=TRUE)
Tr_NSS <- read.table("/home/kuba/Desktop/Tropical_NSS.fst", header=TRUE)
SS_NSS <- read.table("/home/kuba/Desktop/SS_NSS.fst", header=TRUE)
Idt_1_SS_1 <- read.table("/home/kuba/Desktop/Iodent_era1_SS_era1.fst", header=TRUE)
Idt_2_SS_2 <- read.table("/home/kuba/Desktop/Iodent_era2_SS_era2.fst", header=TRUE)
Idt_1vs2 <- read.table("/home/kuba/Desktop/Iodent_era1_era2.fst", header=TRUE)
SS_1vs2 <- read.table("/home/kuba/Desktop/SS_era1_era2.fst", header=TRUE)

Mx_Pv$Fst <- pmax(Mx_Pv$Fst, 0)
Pv_Tr$Fst <- pmax(Pv_Tr$Fst, 0)
Tr_Idt_1$Fst <- pmax(Tr_Idt_1$Fst, 0)
Tr_SS_1$Fst <- pmax(Tr_SS_1$Fst, 0)
Tr_NSS$Fst <- pmax(Tr_NSS$Fst, 0)
SS_NSS$Fst <- pmax(SS_NSS$Fst, 0)
Idt_1_SS_1$Fst <- pmax(Idt_1_SS_1$Fst, 0)
Idt_2_SS_2$Fst <- pmax(Idt_2_SS_2$Fst, 0)
Idt_1vs2$Fst <- pmax(Idt_1vs2$Fst, 0)
SS_1vs2$Fst <- pmax(SS_1vs2$Fst, 0)

Mx_Pv_clean <- Mx_Pv[!is.na(Mx_Pv$Fst), ]
Pv_Tr_clean <- Pv_Tr[!is.na(Pv_Tr$Fst), ]
Tr_Idt_1_clean <- Tr_Idt_1[!is.na(Tr_Idt_1$Fst), ]
Tr_SS_1_clean <- Tr_SS_1[!is.na(Tr_SS_1$Fst), ]
Tr_NSS_clean <- Tr_NSS[!is.na(Tr_NSS$Fst), ]
SS_NSS_clean <- SS_NSS[!is.na(SS_NSS$Fst), ]
Idt_1_SS_1_clean <- Idt_1_SS_1[!is.na(Idt_1_SS_1$Fst), ]
Idt_2_SS_2_clean <- Idt_2_SS_2[!is.na(Idt_2_SS_2$Fst), ]
Idt_1vs2_clean <- Idt_1vs2[!is.na(Idt_1vs2$Fst), ]
SS_1vs2_clean <- SS_1vs2[!is.na(SS_1vs2$Fst), ]

summary(Mx_Tr_clean$Fst)
summary(Pv_Tr_clean$Fst)
summary(Tr_Idt_1_clean$Fst)
summary(Tr_SS_1_clean$Fst)
summary(Tr_NSS_clean$Fst)
summary(SS_NSS_clean$Fst)
summary(Idt_1_SS_1_clean$Fst)
summary(Idt_2_SS_2_clean$Fst)
summary(Idt_1vs2_clean$Fst)
summary(SS_1vs2_clean$Fst)

fst_all <- rbind(
  data.frame(Group = "Mexicana vs. Parviglumis", Fst = Mx_Pv_clean$Fst),
  data.frame(Group = "Parviglumis vs. Tropical", Fst = Pv_Tr_clean$Fst),
  data.frame(Group = "Tropical vs. Iodent I", Fst = Tr_Idt_1_clean$Fst),
  data.frame(Group = "Tropical vs. SS I", Fst = Tr_SS_1_clean$Fst),
  data.frame(Group = "Tropical vs. NSS", Fst = Tr_NSS_clean$Fst),
  data.frame(Group = "SS vs. NSS", Fst = SS_NSS_clean$Fst),
  data.frame(Group = "Iodent I vs. SS I", Fst = Idt_1_SS_1_clean$Fst),
  data.frame(Group = "Iodent II vs. SS II", Fst = Idt_2_SS_2_clean$Fst),
  data.frame(Group = "Iodent I vs. II", Fst = Idt_1vs2_clean$Fst),
  data.frame(Group = "SS I vs. II", Fst = SS_1vs2_clean$Fst)
)

fst_all$Group <- factor(
  fst_all$Group,
  levels = c("Mexicana vs. Parviglumis","Parviglumis vs. Tropical","Tropical vs. Iodent I","Tropical vs. SS I",
             "Tropical vs. NSS","SS vs. NSS","Iodent I vs. SS I","Iodent II vs. SS II",
             "Iodent I vs. II","SS I vs. II")
)

library(ggplot2)

png(file="/home/kuba/Desktop/fst_all.png", width=950, height=700, res=150)
ggplot(fst_all, aes(x = Group, y = Fst)) +
  geom_boxplot(fill = "aquamarine2") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        axis.title.x = element_text(size = 13, margin = margin(t = 12), face = "bold"),
        axis.title.y = element_text(size = 13, margin = margin(r = 12), face = "bold"),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 15, face = "bold", hjust = 0.5),
        plot.margin = margin(11, 11, 11, 20)) +
  labs(title = "fixation index between groups",
       x = "group",
       y = "fst")
dev.off()


################################


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
  data.frame(Group = "Tropical vs. Iodent I", Fst = Tr_Idt_1_clean$Fst),
  data.frame(Group = "Tropical vs. SS I", Fst = Tr_SS_1_clean$Fst),
  data.frame(Group = "Iodent I vs. Iodent II", Fst = Idt_1vs2_clean$Fst),
  data.frame(Group = "SS I vs. SS II", Fst = SS_1vs2_clean$Fst)
)

fst_all$Group <- factor(
  fst_all$Group,
  levels = c("Parviglumis vs. Tropical","Tropical vs. Iodent I","Tropical vs. SS I",
             "Iodent I vs. Iodent II","SS I vs. SS II")
)

library(ggplot2)

png(file="C:/Users/kjlis/Desktop/fst_all_2.png", width=1100, height=1300, res=200)
ggplot(fst_all, aes(x = Group, y = Fst)) +
  geom_boxplot(fill = "aquamarine3") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        axis.title.x = element_text(size = 11, margin = margin(t = 12), face = "bold"),
        axis.title.y = element_text(size = 11, margin = margin(r = 12), face = "bold"),
        axis.text.y = element_text(size = 10),
        plot.title = element_text(size = 12, face = "bold", hjust = 0.5, margin = margin(b = 15)),
        plot.margin = margin(10, 10, 10, 10)) +
  labs(title = "fixation index between subpopulations",
       x = "compared subpopulations",
       y = "FST")
dev.off()

