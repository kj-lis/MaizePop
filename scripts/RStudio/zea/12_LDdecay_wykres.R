library(data.table)
library(ggplot2)
library(R.utils)

file1 <- "C:/Users/kjlis/Desktop/zea_1_LD.stat.gz"

file1_unzipped <- tempfile(fileext = ".stat")
gunzip(file1, destname = file1_unzipped, overwrite = TRUE, remove = FALSE)

ld <- fread(file1_unzipped)

setnames(ld, "#Dist", "Dist")
setnames(ld, "Mean_r^2", "Mean_r2")

head(ld,5)
nrow(ld)

ld_sample <- ld[seq(1, .N, by = 10)]

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
library(R.utils)

files <- list.files("C:/Users/kjlis/Desktop/zea_LD",
                    pattern = "_LD.stat.gz$",
                    full.names = TRUE)

read_ld_gz <- function(file_path) {
  tmp <- tempfile(fileext = ".stat")
  gunzip(file_path, destname = tmp, overwrite = TRUE, remove = FALSE)
  
  dt <- fread(tmp)
  
  if ("#Dist" %in% names(dt)) setnames(dt, "#Dist", "Dist")
  if ("Mean_r^2" %in% names(dt)) setnames(dt, "Mean_r^2", "Mean_r2")
  
  dt[, Subpop := gsub("zea_|_LD.stat.gz", "", basename(file_path))]
  
  return(dt)
}

ld_all <- rbindlist(lapply(files, read_ld_gz))

ld_sample <- ld_all[seq(1, .N, by = 50)]

p <- ggplot(ld_sample, aes(x = Dist/1000, y = Mean_r2, color = Subpop)) +
  geom_line(se = FALSE, span = 0.15, linewidth = 1.2) +
  geom_hline(yintercept = 0.2, linetype = "dashed") +
  theme_classic(base_size = 14) +
  labs(x = "Distance (kb)",
       y = expression(r^2),
       color = "Subpopulation",
       title = "LD decay - wszystkie subpopulacje")

print(p)

ggsave("LD_decay_subpops.png", plot = p,
       width = 8, height = 6, units = "in", dpi = 300)