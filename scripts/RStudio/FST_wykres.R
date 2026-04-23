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

png(file="C:/Users/kjlis/Desktop/fst_1.png", width=1850, height=2000, res=250)
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
Idt_2_NSS_clean <- Idt_2_NSS[!is.na(Idt_2_NSS$Fst), ]
SS_1_NSS_clean <- SS_1_NSS[!is.na(SS_1_NSS$Fst), ]
SS_2_NSS_clean <- SS_2_NSS[!is.na(SS_2_NSS$Fst), ]

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

png(file="C:/Users/kjlis/Desktop/fst_2.png", width=1850, height=2000, res=250)
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

library(dplyr)

Pv_Tr <- read.table("C:/Users/kjlis/Desktop/Pv_Tr_all_windows.csv", sep = ",", header=TRUE)
Tr_Idt_1 <- read.table("C:/Users/kjlis/Desktop/Tr_Idt_1_all_windows.csv", sep = ",", header=TRUE)
Tr_SS_1 <- read.table("C:/Users/kjlis/Desktop/Tr_SS_1_all_windows.csv", sep = ",", header=TRUE)
Idt_1vs2 <- read.table("C:/Users/kjlis/Desktop/Idt_1vs2_all_windows.csv", sep = ",", header=TRUE)
SS_1vs2 <- read.table("C:/Users/kjlis/Desktop/SS_1vs2_all_windows.csv", sep = ",", header=TRUE)

Pv_Tr$MeanY <- pmax(Pv_Tr$MeanY, 0)
Tr_Idt_1$MeanY <- pmax(Tr_Idt_1$MeanY, 0)
Tr_SS_1$MeanY <- pmax(Tr_SS_1$MeanY, 0)
Idt_1vs2$MeanY <- pmax(Idt_1vs2$MeanY, 0)
SS_1vs2$MeanY <- pmax(SS_1vs2$MeanY, 0)

Pv_Tr <- Pv_Tr %>%filter(!is.na(MeanY))
Tr_Idt_1 <- Tr_Idt_1 %>%filter(!is.na(MeanY))
Tr_SS_1 <- Tr_SS_1 %>%filter(!is.na(MeanY))
Idt_1vs2 <- Idt_1vs2 %>%filter(!is.na(MeanY))
SS_1vs2 <- SS_1vs2 %>%filter(!is.na(MeanY))

summary(Pv_Tr$MeanY)
summary(Tr_Idt_1$MeanY)
summary(Tr_SS_1$MeanY)
summary(Idt_1vs2$MeanY)
summary(SS_1vs2$MeanY)

MeanY_all <- rbind(
  data.frame(Group = "Parviglumis vs. Tropical", MeanY = Pv_Tr$MeanY),
  data.frame(Group = "Tropical vs. Iodent I", MeanY = Tr_Idt_1$MeanY),
  data.frame(Group = "Tropical vs. SS I", MeanY = Tr_SS_1$MeanY),
  data.frame(Group = "Iodent I vs. Iodent II", MeanY = Idt_1vs2$MeanY),
  data.frame(Group = "SS I vs. SS II", MeanY = SS_1vs2$MeanY)
)

MeanY_all$Group <- factor(
  MeanY_all$Group,
  levels = c("Parviglumis vs. Tropical","Tropical vs. Iodent I","Tropical vs. SS I",
             "Iodent I vs. Iodent II","SS I vs. SS II")
)

library(ggplot2)

png(file="C:/Users/kjlis/Desktop/MeanY_1.png", width=1850, height=2000, res=250)
ggplot(MeanY_all, aes(x = Group, y = MeanY)) +
  geom_boxplot(fill = "hotpink3") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 13, color = "black"),
        axis.title.x = element_text(size = 14, margin = margin(t = 14), face = "bold", color = "black"),
        axis.title.y = element_text(size = 14, margin = margin(r = 14), face = "bold", color = "black"),
        axis.text.y = element_text(size = 13, color = "black")) +
  labs(
    x = "compared subpopulations",
    y = "MeanY")
dev.off()


################################


library(dplyr)

Idt_1_SS_1 <- read.table("C:/Users/kjlis/Desktop/Idt_1_SS_1_all_windows.csv", sep = ",", header=TRUE)
Idt_2_SS_2 <- read.table("C:/Users/kjlis/Desktop/Idt_2_SS_2_all_windows.csv", sep = ",", header=TRUE)
Idt_1_NSS <- read.table("C:/Users/kjlis/Desktop/Idt_1_NSS_all_windows.csv", sep = ",", header=TRUE)
Idt_2_NSS <- read.table("C:/Users/kjlis/Desktop/Idt_2_NSS_all_windows.csv", sep = ",", header=TRUE)
SS_1_NSS <- read.table("C:/Users/kjlis/Desktop/SS_1_NSS_all_windows.csv", sep = ",", header=TRUE)
SS_2_NSS <- read.table("C:/Users/kjlis/Desktop/SS_2_NSS_all_windows.csv", sep = ",", header=TRUE)

Idt_1_SS_1$MeanY <- pmax(Idt_1_SS_1$MeanY, 0)
Idt_2_SS_2$MeanY <- pmax(Idt_2_SS_2$MeanY, 0)
Idt_1_NSS$MeanY <- pmax(Idt_1_NSS$MeanY, 0)
Idt_2_NSS$MeanY <- pmax(Idt_2_NSS$MeanY, 0)
SS_1_NSS$MeanY <- pmax(SS_1_NSS$MeanY, 0)
SS_2_NSS$MeanY <- pmax(SS_2_NSS$MeanY, 0)

Idt_1_SS_1 <- Idt_1_SS_1[!is.na(Idt_1_SS_1$MeanY), ]
Idt_2_SS_2 <- Idt_2_SS_2[!is.na(Idt_2_SS_2$MeanY), ]
Idt_1_NSS <- Idt_1_NSS[!is.na(Idt_1_NSS$MeanY), ]
Idt_2_NSS <- Idt_2_NSS[!is.na(Idt_2_NSS$MeanY), ]
SS_1_NSS <- SS_1_NSS[!is.na(SS_1_NSS$MeanY), ]
SS_2_NSS <- SS_2_NSS[!is.na(SS_2_NSS$MeanY), ]

summary(Idt_1_SS_1$MeanY)
summary(Idt_2_SS_2$MeanY)
summary(Idt_1_NSS$MeanY)
summary(Idt_2_NSS$MeanY)
summary(SS_1_NSS$MeanY)
summary(SS_2_NSS$MeanY)

MeanY_all <- rbind(
  data.frame(Group = "Iodent I vs. SS I", Fst = Idt_1_SS_1_clean$MeanY),
  data.frame(Group = "Iodent II vs. SS II", Fst = Idt_2_SS_2_clean$MeanY),
  data.frame(Group = "Iodent I vs. NSS", Fst = Idt_1_NSS_clean$MeanY),
  data.frame(Group = "Iodent II vs. NSS", Fst = Idt_2_NSS_clean$MeanY),
  data.frame(Group = "SS I vs. NSS", Fst = SS_1_NSS_clean$MeanY),
  data.frame(Group = "SS II vs. NSS", Fst = SS_2_NSS_clean$MeanY)
)

MeanY_all$Group <- factor(
  MeanY_all$Group,
  levels = c("Iodent I vs. SS I", "Iodent II vs. SS II", "Iodent I vs. NSS", "Iodent II vs. NSS",
             "SS I vs. NSS", "SS II vs. NSS")
)

library(ggplot2)

png(file="C:/Users/kjlis/Desktop/MeanY_2.png", width=1850, height=2000, res=250)
ggplot(MeanY_all, aes(x = Group, y = MeanY)) +
  geom_boxplot(fill = "hotpink3") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 13, color = "black"),
        axis.title.x = element_text(size = 14, margin = margin(t = 14), face = "bold", color = "black"),
        axis.title.y = element_text(size = 14, margin = margin(r = 14), face = "bold", color = "black"),
        axis.text.y = element_text(size = 13, color = "black")) +
  labs(
    x = "compared subpopulations",
    y = "MeanY")
dev.off()