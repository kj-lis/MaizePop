library(data.table)

# Wczytaj wszystkie pliki FST
files <- list.files(path="results/full/zea_fst/", pattern="*.fst", full.names=TRUE)
fst_list <- lapply(files, fread)

# Połącz w jeden data.table
fst_all <- rbindlist(fst_list)

# Średni FST między populacjami
mean_fst <- mean(fst_all$FST, na.rm=TRUE)


############################


library(data.table)

subpops <- c("Subpop1","Subpop2","Subpop3","Subpop4","Subpop5")
pairs <- combn(subpops, 2)  # wszystkie pary

fst_results <- data.table()

for (k in 1:ncol(pairs)) {
  f1 <- pairs[1,k]
  f2 <- pairs[2,k]
  file <- paste0("fst_",f1,"_",f2,".weir.fst")
  fst <- fread(file)
  mean_fst <- mean(fst$WEIR_AND_COCKERHAM_FST, na.rm=TRUE)
  fst_results <- rbind(fst_results, data.table(Pop1=f1, Pop2=f2, Mean_FST=mean_fst))
}

fst_results