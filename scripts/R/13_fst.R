library(data.table)

# Wczytaj wszystkie pliki FST
files <- list.files(path="results/full/zea_fst/", pattern="*.fst", full.names=TRUE)
fst_list <- lapply(files, fread)

# Połącz w jeden data.table
fst_all <- rbindlist(fst_list)

# Średni FST między populacjami
mean_fst <- mean(fst_all$FST, na.rm=TRUE)