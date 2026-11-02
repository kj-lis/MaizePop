
# ============================================================
# WCZYTYWANIE DANYCH KALLISTO I METADANYCH
# ============================================================

library(tximport)

# 1. SCIEZKI DO DANYCH
kallisto_dir <- "C:/Users/YourName/Desktop/kallisto"
metadata_file <- "C:/Users/YourName/Desktop/metadata.csv"
tx2gene_file <- "C:/Users/YourName/Desktop/tx2gene.csv"

# 2. WCZYTANIE METADANYCH
metadata <- read.csv(
  metadata_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# Kolumna sample musi zawierac nazwy folderow probek
stopifnot("sample" %in% colnames(metadata))
stopifnot(!anyNA(metadata$sample))
stopifnot(!anyDuplicated(metadata$sample))

# 3. AUTOMATYCZNE ZNAJDOWANIE FOLDEROW PROBEK
sample_dirs <- list.dirs(
  path = kallisto_dir,
  recursive = FALSE,
  full.names = TRUE
)

sample_ids <- basename(sample_dirs)

# 4. SCIEZKI DO PLIKOW abundance.tsv
files <- file.path(sample_dirs, "abundance.tsv")
names(files) <- sample_ids

# 5. SPRAWDZENIE PLIKOW
if (!all(file.exists(files))) {
  stop(
    "Brakuje abundance.tsv w folderach: ",
    paste(
      sample_ids[!file.exists(files)],
      collapse = ", "
    )
  )
}

# 6. SPRAWDZENIE ZGODNOSCI Z METADANYMI
missing_samples <- setdiff(metadata$sample, names(files))
extra_samples <- setdiff(names(files), metadata$sample)

if (length(missing_samples) > 0) {
  stop(
    "Brakuje probek: ",
    paste(missing_samples, collapse = ", ")
  )
}

if (length(extra_samples) > 0) {
  warning(
    "Dodatkowe probki w kallisto: ",
    paste(extra_samples, collapse = ", ")
  )
}

# 7. USTAWIENIE KOLEJNOSCI PROBEK
files <- files[metadata$sample]

stopifnot(!anyNA(files))

# 8. WCZYTANIE MAPOWANIA TRANSKRYPT-GEN
tx2gene <- read.csv(
  tx2gene_file,
  stringsAsFactors = FALSE
)

stopifnot(ncol(tx2gene) >= 2)

tx2gene <- tx2gene[, 1:2]
colnames(tx2gene) <- c("TXNAME", "GENEID")

# 9. IMPORT WYNIKOW KALLISTO
txi <- tximport(
  files = files,
  type = "kallisto",
  tx2gene = tx2gene,
  countsFromAbundance = "lengthScaledTPM"
)

# 10. MACIERZ EKSPRESJI GENOW
counts <- txi$counts

# 11. KONTROLA POPRAWNOSCI
stopifnot(
  identical(colnames(counts), metadata$sample)
)

cat("Liczba probek:", ncol(counts), "\n")
cat("Liczba genow:", nrow(counts), "\n")

print(head(counts))
print(head(metadata))

# 12. ZAPIS DANYCH DO DALSZEJ ANALIZY
saveRDS(
  list(
    counts = counts,
    metadata = metadata,
    txi = txi
  ),
  file = "kallisto_import.rds"
)

cat("Import zakonczony pomyslnie!\n")
