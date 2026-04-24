################################


Pv_Tr <- read.table("/home/kuba/Desktop/Parviglumis_Tropical.fst", header=TRUE)
Tr_Idt_1 <- read.table("/home/kuba/Desktop/Tropical_Iodent_1.fst", header=TRUE)
Tr_SS_1 <- read.table("/home/kuba/Desktop/Tropical_SS_1.fst", header=TRUE)
Idt_1vs2 <- read.table("/home/kuba/Desktop/Iodent_1vs2.fst", header=TRUE)
SS_1vs2 <- read.table("/home/kuba/Desktop/SS_1vs2.fst", header=TRUE)

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

library(GenWin)
library(dplyr)



Pv_Tr_spline_list <- list()
for (i in 1:10) {
  chr_data_Pv_Tr <- Pv_Tr_clean[Pv_Tr_clean$Chr == i, ]
  Pv_Tr_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Pv_Tr$Fst,
    map = chr_data_Pv_Tr$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Pv_Tr_spline_list) <- paste0("chr", 1:10)

Pv_Tr_results <- list()
Pv_Tr_all_windows <- list()

for (i in 1:10) {
  spline_obj_Pv_Tr <- Pv_Tr_spline_list[[i]]
  window_data_Pv_Tr <- spline_obj_Pv_Tr[["windowData"]]
  
  all_data_Pv_Tr <- window_data_Pv_Tr %>%
    mutate(chromosome = paste0("chr", i))
  Pv_Tr_all_windows[[i]] <- all_data_Pv_Tr
  
  candidates_Pv_Tr <- window_data_Pv_Tr %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  Pv_Tr_results[[i]] <- candidates_Pv_Tr
}

names(Pv_Tr_results) <- paste0("chr", 1:10)
names(Pv_Tr_all_windows) <- paste0("chr", 1:10)

all_candidates_Pv_Tr <- bind_rows(Pv_Tr_results)
all_windows_Pv_Tr <- bind_rows(Pv_Tr_all_windows)

write.csv(all_candidates_Pv_Tr, "/home/kuba/Desktop/Pv_Tr_candidates.csv", row.names = FALSE)
write.csv(all_windows_Pv_Tr, "/home/kuba/Desktop/Pv_Tr_all_windows.csv", row.names = FALSE)



Tr_Idt_1_spline_list <- list()
for (i in 1:10) {
  chr_data_Tr_Idt_1 <- Tr_Idt_1_clean[Tr_Idt_1_clean$Chr == i, ]
  Tr_Idt_1_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Tr_Idt_1$Fst,
    map = chr_data_Tr_Idt_1$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Tr_Idt_1_spline_list) <- paste0("chr", 1:10)

Tr_Idt_1_results <- list()
Tr_Idt_1_all_windows <- list()

for (i in 1:10) {
  spline_obj_Tr_Idt_1 <- Tr_Idt_1_spline_list[[i]]
  window_data_Tr_Idt_1 <- spline_obj_Tr_Idt_1[["windowData"]]
  
  all_data_Tr_Idt_1 <- window_data_Tr_Idt_1 %>%
    mutate(chromosome = paste0("chr", i))
  Tr_Idt_1_all_windows[[i]] <- all_data_Tr_Idt_1
  
  candidates_Tr_Idt_1 <- window_data_Tr_Idt_1 %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  Tr_Idt_1_results[[i]] <- candidates_Tr_Idt_1
}

names(Tr_Idt_1_results) <- paste0("chr", 1:10)
names(Tr_Idt_1_all_windows) <- paste0("chr", 1:10)

all_candidates_Tr_Idt_1 <- bind_rows(Tr_Idt_1_results)
all_windows_Tr_Idt_1 <- bind_rows(Tr_Idt_1_all_windows)

write.csv(all_candidates_Tr_Idt_1, "/home/kuba/Desktop/Tr_Idt_1_candidates.csv", row.names = FALSE)
write.csv(all_windows_Tr_Idt_1, "/home/kuba/Desktop/Tr_Idt_1_all_windows.csv", row.names = FALSE)



Tr_SS_1_spline_list <- list()
for (i in 1:10) {
  chr_data_Tr_SS_1 <- Tr_SS_1_clean[Tr_SS_1_clean$Chr == i, ]
  Tr_SS_1_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Tr_SS_1$Fst,
    map = chr_data_Tr_SS_1$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Tr_SS_1_spline_list) <- paste0("chr", 1:10)

Tr_SS_1_results <- list()
Tr_SS_1_all_windows <- list()

for (i in 1:10) {
  spline_obj_Tr_SS_1 <- Tr_SS_1_spline_list[[i]]
  window_data_Tr_SS_1 <- spline_obj_Tr_SS_1[["windowData"]]
  
  all_data_Tr_SS_1 <- window_data_Tr_SS_1 %>%
    mutate(chromosome = paste0("chr", i))
  Tr_SS_1_all_windows[[i]] <- all_data_Tr_SS_1
  
  candidates_Tr_SS_1 <- window_data_Tr_SS_1 %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  Tr_SS_1_results[[i]] <- candidates_Tr_SS_1
}

names(Tr_SS_1_results) <- paste0("chr", 1:10)
names(Tr_SS_1_all_windows) <- paste0("chr", 1:10)

all_candidates_Tr_SS_1 <- bind_rows(Tr_SS_1_results)
all_windows_Tr_SS_1 <- bind_rows(Tr_SS_1_all_windows)

write.csv(all_candidates_Tr_SS_1, "/home/kuba/Desktop/Tr_SS_1_candidates.csv", row.names = FALSE)
write.csv(all_windows_Tr_SS_1, "/home/kuba/Desktop/Tr_SS_1_all_windows.csv", row.names = FALSE)



Idt_1vs2_spline_list <- list()
for (i in 1:10) {
  chr_data_Idt_1vs2 <- Idt_1vs2_clean[Idt_1vs2_clean$Chr == i, ]
  Idt_1vs2_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Idt_1vs2$Fst,
    map = chr_data_Idt_1vs2$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Idt_1vs2_spline_list) <- paste0("chr", 1:10)

Idt_1vs2_results <- list()
Idt_1vs2_all_windows <- list()

for (i in 1:10) {
  spline_obj_Idt_1vs2 <- Idt_1vs2_spline_list[[i]]
  window_data_Idt_1vs2 <- spline_obj_Idt_1vs2[["windowData"]]
  
  all_data_Idt_1vs2 <- window_data_Idt_1vs2 %>%
    mutate(chromosome = paste0("chr", i))
  Idt_1vs2_all_windows[[i]] <- all_data_Idt_1vs2
  
  candidates_Idt_1vs2<- window_data_Idt_1vs2 %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  Idt_1vs2_results[[i]] <- candidates_Idt_1vs2
}

names(Idt_1vs2_results) <- paste0("chr", 1:10)
names(Idt_1vs2_all_windows) <- paste0("chr", 1:10)

all_candidates_Idt_1vs2 <- bind_rows(Idt_1vs2_results)
all_windows_Idt_1vs2 <- bind_rows(Idt_1vs2_all_windows)

write.csv(all_candidates_Idt_1vs2, "/home/kuba/Desktop/Idt_1vs2_candidates.csv", row.names = FALSE)
write.csv(all_windows_Idt_1vs2, "/home/kuba/Desktop/Idt_1vs2_all_windows.csv", row.names = FALSE)



SS_1vs2_spline_list <- list()
for (i in 1:10) {
  chr_data_SS_1vs2 <- SS_1vs2_clean[SS_1vs2_clean$Chr == i, ]
  SS_1vs2_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_SS_1vs2$Fst,
    map = chr_data_SS_1vs2$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(SS_1vs2_spline_list) <- paste0("chr", 1:10)

SS_1vs2_results <- list()
SS_1vs2_all_windows <- list()

for (i in 1:10) {
  spline_obj_SS_1vs2 <- SS_1vs2_spline_list[[i]]
  window_data_SS_1vs2 <- spline_obj_SS_1vs2[["windowData"]]
  
  all_data_SS_1vs2 <- window_data_SS_1vs2 %>%
    mutate(chromosome = paste0("chr", i))
  SS_1vs2_all_windows[[i]] <- all_data_SS_1vs2
  
  candidates_SS_1vs2<- window_data_SS_1vs2 %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  SS_1vs2_results[[i]] <- candidates_SS_1vs2
}

names(SS_1vs2_results) <- paste0("chr", 1:10)
names(SS_1vs2_all_windows) <- paste0("chr", 1:10)

all_candidates_SS_1vs2 <- bind_rows(SS_1vs2_results)
all_windows_SS_1vs2 <- bind_rows(SS_1vs2_all_windows)

write.csv(all_candidates_SS_1vs2, "/home/kuba/Desktop/SS_1vs2_candidates.csv", row.names = FALSE)
write.csv(all_windows_SS_1vs2, "/home/kuba/Desktop/SS_1vs2_all_windows.csv", row.names = FALSE)


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
write.csv(Pv_Tr_top10, "C:/Users/kjlis/Desktop/Pv_Tr_top10.csv", row.names = FALSE)

Tr_Idt_1 <- Tr_Idt_1 %>% filter(Wstat > 0)
Tr_Idt_1 <- Tr_Idt_1 %>%filter(!is.na(Wstat))
Tr_Idt_1 <- Tr_Idt_1 %>%mutate(chromosome = gsub("chr", "", chromosome))
Tr_Idt_1 <- Tr_Idt_1 %>%mutate(chromosome = as.numeric(chromosome))
threshold_Tr_Idt_1 <- quantile(Tr_Idt_1$Wstat, 0.95, na.rm = TRUE)
Tr_Idt_1_top10 <- Tr_Idt_1 %>%filter(Wstat >= threshold_Tr_Idt_1)
write.csv(Tr_Idt_1_top10, "C:/Users/kjlis/Desktop/Tr_Idt_1_top10.csv", row.names = FALSE)

Tr_SS_1 <- Tr_SS_1 %>% filter(Wstat > 0)
Tr_SS_1 <- Tr_SS_1 %>%filter(!is.na(Wstat))
Tr_SS_1 <- Tr_SS_1 %>%mutate(chromosome = gsub("chr", "", chromosome))
Tr_SS_1 <- Tr_SS_1 %>%mutate(chromosome = as.numeric(chromosome))
threshold_Tr_SS_1 <- quantile(Tr_SS_1$Wstat, 0.95, na.rm = TRUE)
Tr_SS_1_top10 <- Tr_SS_1 %>%filter(Wstat >= threshold_Tr_SS_1)
write.csv(Tr_SS_1_top10, "C:/Users/kjlis/Desktop/Tr_SS_1_top10.csv", row.names = FALSE)

Idt_1vs2 <- Idt_1vs2 %>% filter(Wstat > 0)
Idt_1vs2 <- Idt_1vs2 %>%filter(!is.na(Wstat))
Idt_1vs2 <- Idt_1vs2 %>%mutate(chromosome = gsub("chr", "", chromosome))
Idt_1vs2 <- Idt_1vs2 %>%mutate(chromosome = as.numeric(chromosome))
threshold_Idt_1vs2 <- quantile(Idt_1vs2$Wstat, 0.95, na.rm = TRUE)
Idt_1vs2_top10 <- Idt_1vs2 %>%filter(Wstat >= threshold_Idt_1vs2)
write.csv(Idt_1vs2_top10, "C:/Users/kjlis/Desktop/Idt_1vs2_top10.csv", row.names = FALSE)

SS_1vs2 <- SS_1vs2 %>% filter(Wstat > 0)
SS_1vs2 <- SS_1vs2 %>%filter(!is.na(Wstat))
SS_1vs2 <- SS_1vs2 %>%mutate(chromosome = gsub("chr", "", chromosome))
SS_1vs2 <- SS_1vs2 %>%mutate(chromosome = as.numeric(chromosome))
threshold_SS_1vs2 <- quantile(SS_1vs2$Wstat, 0.95, na.rm = TRUE)
SS_1vs2_top10 <- SS_1vs2 %>%filter(Wstat >= threshold_Idt_1vs2)
write.csv(SS_1vs2_top10, "C:/Users/kjlis/Desktop/SS_1vs2_top10.csv", row.names = FALSE)


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

library(GenWin)
library(dplyr)



Idt_1_SS_1_spline_list <- list()
for (i in 1:10) {
  chr_data_Idt_1_SS_1 <- Idt_1_SS_1_clean[Idt_1_SS_1_clean$Chr == i, ]
  Idt_1_SS_1_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Idt_1_SS_1$Fst,
    map = chr_data_Idt_1_SS_1$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Idt_1_SS_1_spline_list) <- paste0("chr", 1:10)

Idt_1_SS_1_results <- list()
Idt_1_SS_1_all_windows <- list()

for (i in 1:10) {
  spline_obj_Idt_1_SS_1 <- Idt_1_SS_1_spline_list[[i]]
  window_data_Idt_1_SS_1 <- spline_obj_Idt_1_SS_1[["windowData"]]
  
  all_data_Idt_1_SS_1 <- window_data_Idt_1_SS_1 %>%
    mutate(chromosome = paste0("chr", i))
  Idt_1_SS_1_all_windows[[i]] <- all_data_Idt_1_SS_1
  
  candidates_Idt_1_SS_1 <- window_data_Idt_1_SS_1 %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  Idt_1_SS_1_results[[i]] <- candidates_Idt_1_SS_1
}

names(Idt_1_SS_1_results) <- paste0("chr", 1:10)
names(Idt_1_SS_1_all_windows) <- paste0("chr", 1:10)

all_candidates_Idt_1_SS_1 <- bind_rows(Idt_1_SS_1_results)
all_windows_Idt_1_SS_1 <- bind_rows(Idt_1_SS_1_all_windows)

write.csv(all_candidates_Idt_1_SS_1, "/home/kuba/Desktop/Idt_1_SS_1_candidates.csv", row.names = FALSE)
write.csv(all_windows_Idt_1_SS_1, "/home/kuba/Desktop/Idt_1_SS_1_all_windows.csv", row.names = FALSE)



Idt_2_SS_2_spline_list <- list()
for (i in 1:10) {
  chr_data_Idt_2_SS_2 <- Idt_2_SS_2_clean[Idt_2_SS_2_clean$Chr == i, ]
  Idt_2_SS_2_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Idt_2_SS_2$Fst,
    map = chr_data_Idt_2_SS_2$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Idt_2_SS_2_spline_list) <- paste0("chr", 1:10)

Idt_2_SS_2_results <- list()
Idt_2_SS_2_all_windows <- list()

for (i in 1:10) {
  spline_obj_Idt_2_SS_2 <- Idt_2_SS_2_spline_list[[i]]
  window_data_Idt_2_SS_2 <- spline_obj_Idt_2_SS_2[["windowData"]]
  
  all_data_Idt_2_SS_2 <- window_data_Idt_2_SS_2 %>%
    mutate(chromosome = paste0("chr", i))
  Idt_2_SS_2_all_windows[[i]] <- all_data_Idt_2_SS_2
  
  candidates_Idt_2_SS_2 <- window_data_Idt_2_SS_2 %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  Idt_2_SS_2_results[[i]] <- candidates_Idt_2_SS_2
}

names(Idt_2_SS_2_results) <- paste0("chr", 1:10)
names(Idt_2_SS_2_all_windows) <- paste0("chr", 1:10)

all_candidates_Idt_2_SS_2 <- bind_rows(Idt_2_SS_2_results)
all_windows_Idt_2_SS_2 <- bind_rows(Idt_2_SS_2_all_windows)

write.csv(all_candidates_Idt_2_SS_2, "/home/kuba/Desktop/Idt_2_SS_2_candidates.csv", row.names = FALSE)
write.csv(all_windows_Idt_2_SS_2, "/home/kuba/Desktop/Idt_2_SS_2_all_windows.csv", row.names = FALSE)



Idt_1_NSS_spline_list <- list()
for (i in 1:10) {
  chr_data_Idt_1_NSS <- Idt_1_NSS_clean[Idt_1_NSS_clean$Chr == i, ]
  Idt_1_NSS_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Idt_1_NSS$Fst,
    map = chr_data_Idt_1_NSS$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Idt_1_NSS_spline_list) <- paste0("chr", 1:10)

Idt_1_NSS_results <- list()
Idt_1_NSS_all_windows <- list()

for (i in 1:10) {
  spline_obj_Idt_1_NSS <- Idt_1_NSS_spline_list[[i]]
  window_data_Idt_1_NSS <- spline_obj_Idt_1_NSS[["windowData"]]
  
  all_data_Idt_1_NSS <- window_data_Idt_1_NSS %>%
    mutate(chromosome = paste0("chr", i))
  Idt_1_NSS_all_windows[[i]] <- all_data_Idt_1_NSS
  
  candidates_Idt_1_NSS <- window_data_Idt_1_NSS %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  Idt_1_NSS_results[[i]] <- candidates_Idt_1_NSS
}

names(Idt_1_NSS_results) <- paste0("chr", 1:10)
names(Idt_1_NSS_all_windows) <- paste0("chr", 1:10)

all_candidates_Idt_1_NSS <- bind_rows(Idt_1_NSS_results)
all_windows_Idt_1_NSS <- bind_rows(Idt_1_NSS_all_windows)

write.csv(all_candidates_Idt_1_NSS, "/home/kuba/Desktop/Idt_1_NSS_candidates.csv", row.names = FALSE)
write.csv(all_windows_Idt_1_NSS, "/home/kuba/Desktop/Idt_1_NSS_all_windows.csv", row.names = FALSE)



Idt_2_NSS_spline_list <- list()
for (i in 1:10) {
  chr_data_Idt_2_NSS <- Idt_2_NSS_clean[Idt_2_NSS_clean$Chr == i, ]
  Idt_2_NSS_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Idt_2_NSS$Fst,
    map = chr_data_Idt_2_NSS$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Idt_2_NSS_spline_list) <- paste0("chr", 1:10)

Idt_2_NSS_results <- list()
Idt_2_NSS_all_windows <- list()

for (i in 1:10) {
  spline_obj_Idt_2_NSS <- Idt_2_NSS_spline_list[[i]]
  window_data_Idt_2_NSS <- spline_obj_Idt_2_NSS[["windowData"]]
  
  all_data_Idt_2_NSS <- window_data_Idt_2_NSS %>%
    mutate(chromosome = paste0("chr", i))
  Idt_2_NSS_all_windows[[i]] <- all_data_Idt_2_NSS
  
  candidates_Idt_2_NSS <- window_data_Idt_2_NSS %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  Idt_2_NSS_results[[i]] <- candidates_Idt_2_NSS
}

names(Idt_2_NSS_results) <- paste0("chr", 1:10)
names(Idt_2_NSS_all_windows) <- paste0("chr", 1:10)

all_candidates_Idt_2_NSS <- bind_rows(Idt_2_NSS_results)
all_windows_Idt_2_NSS <- bind_rows(Idt_2_NSS_all_windows)

write.csv(all_candidates_Idt_2_NSS, "/home/kuba/Desktop/Idt_2_NSS_candidates.csv", row.names = FALSE)
write.csv(all_windows_Idt_2_NSS, "/home/kuba/Desktop/Idt_2_NSS_all_windows.csv", row.names = FALSE)



SS_1_NSS_spline_list <- list()
for (i in 1:10) {
  chr_data_SS_1_NSS <- SS_1_NSS_clean[SS_1_NSS_clean$Chr == i, ]
  SS_1_NSS_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_SS_1_NSS$Fst,
    map = chr_data_SS_1_NSS$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(SS_1_NSS_spline_list) <- paste0("chr", 1:10)

SS_1_NSS_results <- list()
SS_1_NSS_all_windows <- list()

for (i in 1:10) {
  spline_obj_SS_1_NSS <- SS_1_NSS_spline_list[[i]]
  window_data_SS_1_NSS <- spline_obj_SS_1_NSS[["windowData"]]
  
  all_data_SS_1_NSS <- window_data_SS_1_NSS %>%
    mutate(chromosome = paste0("chr", i))
  SS_1_NSS_all_windows[[i]] <- all_data_SS_1_NSS
  
  candidates_SS_1_NSS <- window_data_SS_1_NSS %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  SS_1_NSS_results[[i]] <- candidates_SS_1_NSS
}

names(SS_1_NSS_results) <- paste0("chr", 1:10)
names(SS_1_NSS_all_windows) <- paste0("chr", 1:10)

all_candidates_SS_1_NSS <- bind_rows(SS_1_NSS_results)
all_windows_SS_1_NSS <- bind_rows(SS_1_NSS_all_windows)

write.csv(all_candidates_SS_1_NSS, "/home/kuba/Desktop/SS_1_NSS_candidates.csv", row.names = FALSE)
write.csv(all_windows_SS_1_NSS, "/home/kuba/Desktop/SS_1_NSS_all_windows.csv", row.names = FALSE)



SS_2_NSS_spline_list <- list()
for (i in 1:10) {
  chr_data_SS_2_NSS <- SS_2_NSS_clean[SS_2_NSS_clean$Chr == i, ]
  SS_2_NSS_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_SS_2_NSS$Fst,
    map = chr_data_SS_2_NSS$bp,
    smoothness = 300,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(SS_2_NSS_spline_list) <- paste0("chr", 1:10)

SS_2_NSS_results <- list()
SS_2_NSS_all_windows <- list()

for (i in 1:10) {
  spline_obj_SS_2_NSS <- SS_2_NSS_spline_list[[i]]
  window_data_SS_2_NSS <- spline_obj_SS_2_NSS[["windowData"]]
  
  all_data_SS_2_NSS <- window_data_SS_2_NSS %>%
    mutate(chromosome = paste0("chr", i))
  SS_2_NSS_all_windows[[i]] <- all_data_SS_2_NSS
  
  candidates_SS_2_NSS <- window_data_SS_2_NSS %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  
  SS_2_NSS_results[[i]] <- candidates_SS_2_NSS
}

names(SS_2_NSS_results) <- paste0("chr", 1:10)
names(SS_2_NSS_all_windows) <- paste0("chr", 1:10)

all_candidates_SS_2_NSS <- bind_rows(SS_2_NSS_results)
all_windows_SS_2_NSS <- bind_rows(SS_2_NSS_all_windows)

write.csv(all_candidates_SS_2_NSS, "/home/kuba/Desktop/SS_2_NSS_candidates.csv", row.names = FALSE)
write.csv(all_windows_SS_2_NSS, "/home/kuba/Desktop/SS_2_NSS_all_windows.csv", row.names = FALSE)

