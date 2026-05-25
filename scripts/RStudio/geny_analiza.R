
#załadować dane z FST, XP-EHH i XP-CLR
#wyciągnąć top %5 z każdego


#top 5% z XP-EHH --> pamiętać o znaku!

################################


library(dplyr)

Pv_Tr <- read.table("C:/Users/kjlis/Desktop/Spline/Pv_Tr_all_windows.csv", sep = ",", header=TRUE)
Tr_Idt_1 <- read.table("C:/Users/kjlis/Desktop/Spline/Tr_Idt_1_all_windows.csv", sep = ",", header=TRUE)
Tr_SS_1 <- read.table("C:/Users/kjlis/Desktop/Spline/Tr_SS_1_all_windows.csv", sep = ",", header=TRUE)
Idt_1vs2 <- read.table("C:/Users/kjlis/Desktop/Spline/Idt_1vs2_all_windows.csv", sep = ",", header=TRUE)
SS_1vs2 <- read.table("C:/Users/kjlis/Desktop/Spline/SS_1vs2_all_windows.csv", sep = ",", header=TRUE)

Pv_Tr <- Pv_Tr %>% filter(Wstat > 0)
Pv_Tr <- Pv_Tr %>%filter(!is.na(Wstat))
Pv_Tr <- Pv_Tr %>%mutate(chromosome = gsub("chr", "", chromosome))
Pv_Tr <- Pv_Tr %>%mutate(chromosome = as.numeric(chromosome))
threshold_Pv_Tr <- quantile(Pv_Tr$Wstat, 0.95, na.rm = TRUE)
Pv_Tr_top10 <- Pv_Tr %>%filter(Wstat >= threshold_Pv_Tr)
write.csv(Pv_Tr_top10, "C:/Users/kjlis/Desktop/Pv_Tr_top5.csv", row.names = FALSE)

Tr_Idt_1 <- Tr_Idt_1 %>% filter(Wstat > 0)
Tr_Idt_1 <- Tr_Idt_1 %>%filter(!is.na(Wstat))
Tr_Idt_1 <- Tr_Idt_1 %>%mutate(chromosome = gsub("chr", "", chromosome))
Tr_Idt_1 <- Tr_Idt_1 %>%mutate(chromosome = as.numeric(chromosome))
threshold_Tr_Idt_1 <- quantile(Tr_Idt_1$Wstat, 0.95, na.rm = TRUE)
Tr_Idt_1_top10 <- Tr_Idt_1 %>%filter(Wstat >= threshold_Tr_Idt_1)
write.csv(Tr_Idt_1_top10, "C:/Users/kjlis/Desktop/Tr_Idt_1_top5.csv", row.names = FALSE)

Tr_SS_1 <- Tr_SS_1 %>% filter(Wstat > 0)
Tr_SS_1 <- Tr_SS_1 %>%filter(!is.na(Wstat))
Tr_SS_1 <- Tr_SS_1 %>%mutate(chromosome = gsub("chr", "", chromosome))
Tr_SS_1 <- Tr_SS_1 %>%mutate(chromosome = as.numeric(chromosome))
threshold_Tr_SS_1 <- quantile(Tr_SS_1$Wstat, 0.95, na.rm = TRUE)
Tr_SS_1_top10 <- Tr_SS_1 %>%filter(Wstat >= threshold_Tr_SS_1)
write.csv(Tr_SS_1_top10, "C:/Users/kjlis/Desktop/Tr_SS_1_top5.csv", row.names = FALSE)

Idt_1vs2 <- Idt_1vs2 %>% filter(Wstat > 0)
Idt_1vs2 <- Idt_1vs2 %>%filter(!is.na(Wstat))
Idt_1vs2 <- Idt_1vs2 %>%mutate(chromosome = gsub("chr", "", chromosome))
Idt_1vs2 <- Idt_1vs2 %>%mutate(chromosome = as.numeric(chromosome))
threshold_Idt_1vs2 <- quantile(Idt_1vs2$Wstat, 0.95, na.rm = TRUE)
Idt_1vs2_top10 <- Idt_1vs2 %>%filter(Wstat >= threshold_Idt_1vs2)
write.csv(Idt_1vs2_top10, "C:/Users/kjlis/Desktop/Idt_1vs2_top5.csv", row.names = FALSE)

SS_1vs2 <- SS_1vs2 %>% filter(Wstat > 0)
SS_1vs2 <- SS_1vs2 %>%filter(!is.na(Wstat))
SS_1vs2 <- SS_1vs2 %>%mutate(chromosome = gsub("chr", "", chromosome))
SS_1vs2 <- SS_1vs2 %>%mutate(chromosome = as.numeric(chromosome))
threshold_SS_1vs2 <- quantile(SS_1vs2$Wstat, 0.95, na.rm = TRUE)
SS_1vs2_top10 <- SS_1vs2 %>%filter(Wstat >= threshold_Idt_1vs2)
write.csv(SS_1vs2_top10, "C:/Users/kjlis/Desktop/SS_1vs2_top5.csv", row.names = FALSE)

