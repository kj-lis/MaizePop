Pv_Tr <- read.table("/home/kuba/Desktop/Parviglumis_Tropical.fst", header=TRUE)
Tr_Idt_1 <- read.table("/home/kuba/Desktop/Tropical_Iodent_era1.fst", header=TRUE)
Tr_SS_1 <- read.table("/home/kuba/Desktop/Tropical_SS_era1.fst", header=TRUE)
Idt_1vs2 <- read.table("/home/kuba/Desktop/Iodent_era1_era2.fst", header=TRUE)
SS_1vs2 <- read.table("/home/kuba/Desktop/SS_era1_era2.fst", header=TRUE)

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


################################


Pv_Tr_spline_list <- list()
for (i in 1:10) {
  chr_data_Pv_Tr <- Pv_Tr_clean[Pv_Tr_clean$Chr == i, ]
  Pv_Tr_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Pv_Tr$Fst,
    map = chr_data_Pv_Tr$bp,
    smoothness = 200,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Pv_Tr_spline_list) <- paste0("chr", 1:10)

Pv_Tr_results <- list()
for (i in 1:10) {
  spline_obj_Pv_Tr <- Pv_Tr_spline_list[[i]]
  candidates_Pv_Tr <- spline_obj_Pv_Tr[["windowData"]] %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  Pv_Tr_results[[i]] <- candidates_Pv_Tr
}
names(Pv_Tr_results) <- paste0("chr", 1:10)
all_candidates_Pv_Tr <- bind_rows(Pv_Tr_results)
write.csv(all_candidates_Pv_Tr, "/home/kuba/Desktop/Pv_Tr_candidates.csv", row.names = FALSE)


################################


Tr_Idt_1_spline_list <- list()
for (i in 1:10) {
  chr_data_Tr_Idt_1 <- Tr_Idt_1_clean[Tr_Idt_1_clean$Chr == i, ]
  Tr_Idt_1_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Tr_Idt_1$Fst,
    map = chr_data_Tr_Idt_1$bp,
    smoothness = 200,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Tr_Idt_1_spline_list) <- paste0("chr", 1:10)

Tr_Idt_1_results <- list()
for (i in 1:10) {
  spline_obj_Tr_Idt_1 <- Tr_Idt_1_spline_list[[i]]
  candidates_Tr_Idt_1 <- spline_obj_Tr_Idt_1[["windowData"]] %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  Tr_Idt_1_results[[i]] <- candidates_Tr_Idt_1
}
names(Tr_Idt_1_results) <- paste0("chr", 1:10)
all_candidates_Tr_Idt_1 <- bind_rows(Tr_Idt_1_results)
write.csv(all_candidates_Tr_Idt_1, "/home/kuba/Desktop/Tr_Idt_1_candidates.csv", row.names = FALSE)


################################


Tr_SS_1_spline_list <- list()
for (i in 1:10) {
  chr_data_Tr_SS_1 <- Tr_SS_1_clean[Tr_SS_1_clean$Chr == i, ]
  Tr_SS_1_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Tr_SS_1$Fst,
    map = chr_data_Tr_SS_1$bp,
    smoothness = 200,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Tr_SS_1_spline_list) <- paste0("chr", 1:10)

Tr_SS_1_results <- list()
for (i in 1:10) {
  spline_obj_Tr_SS_1 <- Tr_SS_1_spline_list[[i]]
  candidates_Tr_SS_1 <- spline_obj_Tr_SS_1[["windowData"]] %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  Tr_SS_1_results[[i]] <- candidates_Tr_SS_1
}
names(Tr_SS_1_results) <- paste0("chr", 1:10)
all_candidates_Tr_SS_1 <- bind_rows(Tr_SS_1_results)
write.csv(all_candidates_Tr_SS_1, "/home/kuba/Desktop/Tr_SS_1_candidates.csv", row.names = FALSE)


################################


Idt_1vs2_spline_list <- list()
for (i in 1:10) {
  chr_data_Idt_1vs2 <- Idt_1vs2_clean[Idt_1vs2_clean$Chr == i, ]
  Idt_1vs2_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_Idt_1vs2$Fst,
    map = chr_data_Idt_1vs2$bp,
    smoothness = 200,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(Idt_1vs2_spline_list) <- paste0("chr", 1:10)

Idt_1vs2_results <- list()
for (i in 1:10) {
  spline_obj_Idt_1vs2 <- Idt_1vs2_spline_list[[i]]
  candidates_Idt_1vs2 <- spline_obj_Idt_1vs2[["windowData"]] %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  Idt_1vs2_results[[i]] <- candidates_Idt_1vs2
}
names(Idt_1vs2_results) <- paste0("chr", 1:10)
all_candidates_Idt_1vs2 <- bind_rows(Idt_1vs2_results)
write.csv(all_candidates_Idt_1vs2, "/home/kuba/Desktop/Idt_1vs2_candidates.csv", row.names = FALSE)


################################


SS_1vs2_spline_list <- list()
for (i in 1:10) {
  chr_data_SS_1vs2 <- SS_1vs2_clean[SS_1vs2_clean$Chr == i, ]
  SS_1vs2_spline_list[[i]] <- splineAnalyze(
    Y = chr_data_SS_1vs2$Fst,
    map = chr_data_SS_1vs2$bp,
    smoothness = 200,
    plotRaw = TRUE,
    plotWindows = TRUE,
    method = 4
  )
}
names(SS_1vs2_spline_list) <- paste0("chr", 1:10)

SS_1vs2_results <- list()
for (i in 1:10) {
  spline_obj_SS_1vs2 <- SS_1vs2_spline_list[[i]]
  candidates_SS_1vs2 <- spline_obj_SS_1vs2[["windowData"]] %>%
    filter(Wstat >= quantile(Wstat, 0.9, na.rm = TRUE)) %>%
    mutate(chromosome = paste0("chr", i))
  SS_1vs2_results[[i]] <- candidates_SS_1vs2
}
names(SS_1vs2_results) <- paste0("chr", 1:10)
all_candidates_SS_1vs2 <- bind_rows(SS_1vs2_results)
write.csv(all_candidates_SS_1vs2, "/home/kuba/Desktop/SS_1vs2_candidates.csv", row.names = FALSE)

