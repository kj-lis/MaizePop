library(data.table)
library(ggplot2)
library(R.utils)  # do gunzip

# plik subpopulacji
file1 <- "C:/Users/kjlis/Desktop/zea_1_LD.stat.gz"

# rozpakowanie do tymczasowego pliku
file1_unzipped <- tempfile(fileext = ".stat")
gunzip(file1, destname = file1_unzipped, overwrite = TRUE, remove = FALSE)

# wczytanie danych
ld <- fread(file1_unzipped)

# uproszczenie nazw kolumn
setnames(ld, "#Dist", "Dist")
setnames(ld, "Mean_r^2", "Mean_r2")

# sprawdzenie wczytanych danych
head(ld,5)
nrow(ld)   # powinno być > 0

ld_sample <- ld[seq(1, .N, by = 10)]

# wykres LD decay
p <- ggplot(ld_sample, aes(x = Dist/1000, y = Mean_r2)) +
  geom_line(color = "blue", linewidth = 1) +
  geom_hline(yintercept = 0.2, linetype = "dashed") +
  theme_classic(base_size = 14) +
  labs(x = "Distance (kb)", y = expression(r^2),
       title = "LD decay - Subpopulation 1")


print(p)



################################



library(data.table)
library(ggplot2)
library(R.utils)  # do gunzip

# lista plików
files <- list.files("C:/Users/kjlis/Desktop/zea_LD",
                    pattern = "_LD.stat.gz$",
                    full.names = TRUE)

# funkcja do wczytania i rozpakowania pojedynczego pliku
read_ld_gz <- function(file_path) {
  # tymczasowy plik do rozpakowania
  tmp <- tempfile(fileext = ".stat")
  gunzip(file_path, destname = tmp, overwrite = TRUE, remove = FALSE)
  
  # wczytanie danych
  dt <- fread(tmp)
  
  # uproszczenie nazw kolumn
  if ("#Dist" %in% names(dt)) setnames(dt, "#Dist", "Dist")
  if ("Mean_r^2" %in% names(dt)) setnames(dt, "Mean_r^2", "Mean_r2")
  
  # dodanie kolumny subpopulacji
  dt[, Subpop := gsub("zea_|_LD.stat.gz", "", basename(file_path))]
  
  return(dt)
}

# wczytanie wszystkich plików i połączenie
ld_all <- rbindlist(lapply(files, read_ld_gz))

# próbka danych dla mniejszego pliku (co 10. wiersz)
ld_sample <- ld_all[seq(1, .N, by = 50)]

# wykres LD decay dla wszystkich subpopulacji
p <- ggplot(ld_sample, aes(x = Dist/1000, y = Mean_r2, color = Subpop)) +
  geom_line(se = FALSE, span = 0.15, linewidth = 1.2) +
  geom_hline(yintercept = 0.2, linetype = "dashed") +
  theme_classic(base_size = 14) +
  labs(x = "Distance (kb)",
       y = expression(r^2),
       color = "Subpopulation",
       title = "LD decay - wszystkie subpopulacje")

print(p)

# zapis do lekkiego PNG ??
ggsave("LD_decay_subpops.png", plot = p,
       width = 8, height = 6, units = "in", dpi = 300)