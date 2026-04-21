################################


Pv_Tr <- read.table("C:/Users/kjlis/Desktop/Parviglumis_Tropical.fst", header=TRUE)
Tr_Idt_1 <- read.table("C:/Users/kjlis/Desktop/Tropical_Iodent_1.fst", header=TRUE)
Tr_SS_1 <- read.table("C:/Users/kjlis/Desktop/Tropical_SS_1.fst", header=TRUE)
Idt_1vs2 <- read.table("C:/Users/kjlis/Desktop/Iodent_1vs2.fst", header=TRUE)
SS_1vs2 <- read.table("C:/Users/kjlis/Desktop/SS_1vs2.fst", header=TRUE)

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

png(file="C:/Users/kjlis/Desktop/fst_1.png", width=1800, height=2000, res=250)
ggplot(fst_all, aes(x = Group, y = Fst)) +
  geom_boxplot(fill = "mediumturquoise") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 13, color = "black"),
    axis.title.x = element_text(size = 14, margin = margin(t = 14), face = "bold", color = "black"),
    axis.title.y = element_text(size = 14, margin = margin(r = 14), face = "bold", color = "black"),
    axis.text.y = element_text(size = 13, color = "black")) +
  labs(
    x = "compared subpopulations",
    y = expression(bold(F[ST])))
dev.off()


################################


Idt_1_SS_1 <- read.table("C:/Users/kjlis/Desktop/Iodent_1_SS_1.fst", header=TRUE)
Idt_2_SS_2 <- read.table("C:/Users/kjlis/Desktop/Iodent_2_SS_2.fst", header=TRUE)
Idt_1_NSS <- read.table("C:/Users/kjlis/Desktop/Iodent_1_NSS.fst", header=TRUE)
Idt_2_NSS <- read.table("C:/Users/kjlis/Desktop/Iodent_2_NSS.fst", header=TRUE)
SS_1_NSS <- read.table("C:/Users/kjlis/Desktop/SS_1_NSS.fst", header=TRUE)
SS_2_NSS <- read.table("C:/Users/kjlis/Desktop/SS_2_NSS.fst", header=TRUE)

Idt_1_SS_1$Fst <- pmax(Idt_1_SS_1$Fst, 0)
Idt_2_SS_2$Fst <- pmax(Idt_2_SS_2$Fst, 0)
Idt_1_NSS$Fst <- pmax(Idt_1_NSS$Fst, 0)
Idt_2_NSS$Fst <- pmax(Idt_2_NSS$Fst, 0)
SS_1_NSS$Fst <- pmax(SS_1_NSS$Fst, 0)
SS_2_NSS$Fst <- pmax(SS_2_NSS$Fst, 0)

Idt_1_SS_1_clean <- Idt_1_SS_1[!is.na(Idt_1_SS_1$Fst), ]
Idt_2_SS_2_clean <- Idt_2_SS_2[!is.na(Idt_2_SS_2$Fst), ]
Idt_1_NSS_clean <- Idt_1_NSS[!is.na(Idt_1_NSS$Fst), ]
Idt_2_NSS_clean <- Idt_1_NSS[!is.na(Idt_1_NSS$Fst), ]
SS_1_NSS_clean <- Idt_1_NSS[!is.na(Idt_1_NSS$Fst), ]
SS_2_NSS_clean <- Idt_1_NSS[!is.na(Idt_1_NSS$Fst), ]

summary(Idt_1_SS_1_clean$Fst)
summary(Idt_2_SS_2_clean$Fst)
summary(Idt_1_NSS_clean$Fst)
summary(Idt_2_NSS_clean$Fst)
summary(SS_1_NSS_clean$Fst)
summary(SS_2_NSS_clean$Fst)

fst_all <- rbind(
  data.frame(Group = "Iodent I vs. SS I", Fst = Idt_1_SS_1_clean$Fst),
  data.frame(Group = "Iodent II vs. SS II", Fst = Idt_2_SS_2_clean$Fst),
  data.frame(Group = "Iodent I vs. NSS", Fst = Idt_1_NSS_clean$Fst),
  data.frame(Group = "Iodent II vs. NSS", Fst = Idt_2_NSS_clean$Fst),
  data.frame(Group = "SS I vs. NSS", Fst = SS_1_NSS_clean$Fst),
  data.frame(Group = "SS II vs. NSS", Fst = SS_2_NSS_clean$Fst)
)

fst_all$Group <- factor(
  fst_all$Group,
  levels = c("Iodent I vs. SS I", "Iodent II vs. SS II", "Iodent I vs. NSS", "Iodent II vs. NSS",
             "SS I vs. NSS", "SS II vs. NSS")
)

library(ggplot2)

png(file="C:/Users/kjlis/Desktop/fst_2.png", width=1800, height=2000, res=250)
ggplot(fst_all, aes(x = Group, y = Fst)) +
  geom_boxplot(fill = "mediumturquoise") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 13, color = "black"),
        axis.title.x = element_text(size = 14, margin = margin(t = 14), face = "bold", color = "black"),
        axis.title.y = element_text(size = 14, margin = margin(r = 14), face = "bold", color = "black"),
        axis.text.y = element_text(size = 13, color = "black")) +
  labs(
    x = "compared subpopulations",
    y = expression(bold(F[ST])))
dev.off()