# ============================================================
# ANALIZA DEG: KALLISTO + LIMMA (ID + condition)
# ============================================================

# 1. PAKIETY

library(tximport)
library(edgeR)
library(limma)
library(ggplot2)
library(pheatmap)

# ============================================================
# 2. SCIEZKI - ZMIEN NA SWOJE
# ============================================================

project_dir <- "C:/Users/YourName/Desktop/Projekt"

kallisto_dir <- file.path(project_dir, "kallisto")
metadata_file <- file.path(project_dir, "metadata.csv")
tx2gene_file <- file.path(project_dir, "tx2gene.csv")

output_dir <- file.path(project_dir, "results_limma")

dir.create(
  output_dir,
  recursive = TRUE,
  showWarnings = FALSE
)


# ============================================================
# 3. WCZYTANIE METADANYCH
# ============================================================

metadata <- read.csv(
  metadata_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

required_cols <- c("sample", "condition", "ID", "era")

stopifnot(all(required_cols %in% colnames(metadata)))

metadata$sample <- trimws(metadata$sample)
metadata$condition <- trimws(metadata$condition)
metadata$ID <- trimws(metadata$ID)

stopifnot(!anyNA(metadata[, required_cols]))
stopifnot(!anyDuplicated(metadata$sample))

metadata$condition <- factor(
  metadata$condition,
  levels = c("control", "cold", "chilling")
)

metadata$ID <- factor(metadata$ID)
metadata$era <- factor(metadata$era)

stopifnot(!anyNA(metadata$condition))

cat("Liczba probek:", nrow(metadata), "\n")

print(table(metadata$condition))
print(table(metadata$era, metadata$condition))
print(table(metadata$ID, metadata$condition))


# ============================================================
# 4. AUTOMATYCZNE WCZYTANIE FOLDEROW KALLISTO
# ============================================================

sample_dirs <- list.dirs(
  kallisto_dir,
  recursive = FALSE,
  full.names = TRUE
)

sample_ids <- basename(sample_dirs)

files <- file.path(
  sample_dirs,
  "abundance.tsv"
)

names(files) <- sample_ids

# Sprawdzenie plikow
if (!all(file.exists(files))) {
  stop(
    "Brak abundance.tsv dla: ",
    paste(
      sample_ids[!file.exists(files)],
      collapse = ", "
    )
  )
}

# Sprawdzenie zgodnosci z metadanymi
missing <- setdiff(metadata$sample, names(files))
extra <- setdiff(names(files), metadata$sample)

if (length(missing) > 0) {
  stop(
    "Brak probek w kallisto: ",
    paste(missing, collapse = ", ")
  )
}

if (length(extra) > 0) {
  warning(
    "Dodatkowe foldery: ",
    paste(extra, collapse = ", ")
  )
}

# Kolejnosc taka sama jak w metadanych
files <- files[metadata$sample]

stopifnot(all(file.exists(files)))

print(files)


# ============================================================
# 5. IMPORT KALLISTO NA POZIOMIE GENOW
# ============================================================

# Plik tx2gene: pierwsza kolumna = transkrypt,
# druga kolumna = gen.
# Identyfikatory musza pasowac do indeksu kallisto.

tx2gene <- read.csv(
  tx2gene_file,
  stringsAsFactors = FALSE
)

stopifnot(ncol(tx2gene) >= 2)

tx2gene <- tx2gene[, 1:2]
colnames(tx2gene) <- c("TXNAME", "GENEID")

stopifnot(!anyNA(tx2gene))
stopifnot(!anyDuplicated(tx2gene$TXNAME))

txi <- tximport(
  files = files,
  type = "kallisto",
  tx2gene = tx2gene,
  countsFromAbundance = "lengthScaledTPM"
)

counts <- txi$counts

stopifnot(
  identical(colnames(counts), metadata$sample)
)

cat("Liczba genow:", nrow(counts), "\n")
cat("Liczba probek:", ncol(counts), "\n")


# ============================================================
# 6. MACIERZ PROJEKTU
# ============================================================

# ID kontroluje roznice miedzy genotypami.
# Control jest poziomem referencyjnym.

design <- model.matrix(
  ~ ID + condition,
  data = metadata
)

print(colnames(design))

# Sprawdzenie identyfikowalnosci modelu
if (qr(design)$rank < ncol(design)) {
  stop("Model nie ma pelnego rzedu. Sprawdz ID i condition.")
}

if (nrow(design) <= ncol(design)) {
  stop(
    "Brak stopni swobody resztowych. ",
    "Potrzebne sa dodatkowe probki lub inny model."
  )
}


# ============================================================
# 7. EDGE R - FILTROWANIE I NORMALIZACJA
# ============================================================

dge <- DGEList(counts = counts)

keep <- filterByExpr(
  dge,
  design = design
)

cat("Geny przed filtrowaniem:", nrow(dge), "\n")
cat("Geny po filtrowaniu:", sum(keep), "\n")

dge <- dge[
  keep,
  ,
  keep.lib.sizes = FALSE
]

dge <- calcNormFactors(
  dge,
  method = "TMM"
)

# Zapis logCPM do wizualizacji
logCPM <- cpm(
  dge,
  log = TRUE,
  prior.count = 2
)


# ============================================================
# 8. LIMMA-VOOM
# ============================================================

pdf(
  file.path(output_dir, "voom_plot.pdf")
)

v <- voom(
  dge,
  design,
  plot = TRUE
)

dev.off()

fit <- lmFit(
  v,
  design
)


# ============================================================
# 9. KONTRASTY
# ============================================================

contrasts <- makeContrasts(
  cold_vs_control = conditioncold,
  chilling_vs_control = conditionchilling,
  cold_vs_chilling =
    conditioncold - conditionchilling,
  levels = design
)

fit_contrasts <- contrasts.fit(
  fit,
  contrasts
)

fit_contrasts <- eBayes(
  fit_contrasts,
  robust = FALSE
)


# ============================================================
# 10. WYNIKI DEG
# ============================================================

results_cold <- topTable(
  fit_contrasts,
  coef = "cold_vs_control",
  number = Inf,
  adjust.method = "BH"
)

results_chilling <- topTable(
  fit_contrasts,
  coef = "chilling_vs_control",
  number = Inf,
  adjust.method = "BH"
)

results_cold_chilling <- topTable(
  fit_contrasts,
  coef = "cold_vs_chilling",
  number = Inf,
  adjust.method = "BH"
)


# ============================================================
# 11. LICZBA GENOW DEG
# ============================================================

deg_cold <- subset(
  results_cold,
  adj.P.Val < 0.05
)

deg_chilling <- subset(
  results_chilling,
  adj.P.Val < 0.05
)

deg_cold_chilling <- subset(
  results_cold_chilling,
  adj.P.Val < 0.05
)

cat("DEG cold vs control:", nrow(deg_cold), "\n")
cat("DEG chilling vs control:", nrow(deg_chilling), "\n")
cat("DEG cold vs chilling:",
    nrow(deg_cold_chilling), "\n")


# ============================================================
# 12. COEFFICIENTS I STANDARD ERRORS
# ============================================================

# Efekty kontrastow
Bhat <- fit_contrasts$coefficients

# Klasyczne SE przed moderacja eBayes
Shat <- sweep(
  fit_contrasts$stdev.unscaled,
  1,
  fit_contrasts$sigma,
  FUN = "*"
)

stopifnot(identical(dim(Bhat), dim(Shat)))

write.csv(
  Bhat,
  file.path(output_dir, "limma_coefficients.csv")
)

write.csv(
  Shat,
  file.path(output_dir, "limma_SE.csv")
)


# ============================================================
# 13. ZAPIS WYNIKOW
# ============================================================

write.csv(
  results_cold,
  file.path(output_dir, "cold_vs_control.csv")
)

write.csv(
  results_chilling,
  file.path(output_dir, "chilling_vs_control.csv")
)

write.csv(
  results_cold_chilling,
  file.path(output_dir, "cold_vs_chilling.csv")
)

write.csv(
  logCPM,
  file.path(output_dir, "logCPM.csv")
)

saveRDS(
  list(
    metadata = metadata,
    design = design,
    dge = dge,
    voom = v,
    fit = fit_contrasts,
    Bhat = Bhat,
    Shat = Shat
  ),
  file.path(output_dir, "limma_objects.rds")
)


# ============================================================
# 14. PCA - KONTROLA JAKOSCI
# ============================================================

pca <- prcomp(
  t(logCPM),
  scale. = FALSE
)

pca_df <- data.frame(
  PC1 = pca$x[, 1],
  PC2 = pca$x[, 2],
  condition = metadata$condition,
  era = metadata$era,
  ID = metadata$ID
)

variance <- 100 * pca$sdev^2 / sum(pca$sdev^2)

p <- ggplot(
  pca_df,
  aes(
    x = PC1,
    y = PC2,
    color = condition,
    shape = era
  )
) +
  geom_point(size = 3) +
  labs(
    title = "PCA - gene expression",
    x = paste0("PC1 (", round(variance[1], 1), "%)"),
    y = paste0("PC2 (", round(variance[2], 1), "%)")
  ) +
  theme_bw()

ggsave(
  file.path(output_dir, "PCA.png"),
  p,
  width = 8,
  height = 6
)


# ============================================================
# 15. VOLCANO PLOT
# ============================================================

plot_volcano <- function(results, title, filename) {
  
  df <- results
  
  df$significant <- ifelse(
    df$adj.P.Val < 0.05,
    "FDR < 0.05",
    "Not significant"
  )
  
  df$negLogP <- -log10(
    pmax(df$P.Value, .Machine$double.xmin)
  )
  
  p <- ggplot(
    df,
    aes(
      x = logFC,
      y = negLogP,
      color = significant
    )
  ) +
    geom_point(alpha = 0.6, size = 1) +
    scale_color_manual(
      values = c(
        "FDR < 0.05" = "red",
        "Not significant" = "grey"
      )
    ) +
    labs(
      title = title,
      x = "log2 Fold Change",
      y = "-log10(p-value)"
    ) +
    theme_bw()
  
  ggsave(
    file.path(output_dir, filename),
    p,
    width = 8,
    height = 6
  )
}

plot_volcano(
  results_cold,
  "Cold vs Control",
  "volcano_cold.png"
)

plot_volcano(
  results_chilling,
  "Chilling vs Control",
  "volcano_chilling.png"
)

plot_volcano(
  results_cold_chilling,
  "Cold vs Chilling",
  "volcano_cold_chilling.png"
)


# ============================================================
# 16. HEATMAPA NAJBARDZIEJ ZMIENNYCH GENOW
# ============================================================

gene_variance <- apply(logCPM, 1, var)

top_genes <- names(
  sort(gene_variance, decreasing = TRUE)
)[seq_len(min(50, nrow(logCPM)))]

annotation <- metadata[, c("condition", "era", "ID")]
rownames(annotation) <- metadata$sample

pheatmap(
  logCPM[top_genes, , drop = FALSE],
  scale = "row",
  annotation_col = annotation,
  filename = file.path(output_dir, "heatmap_top50.png"),
  width = 10,
  height = 9
)


# ============================================================
# 17. KONIEC
# ============================================================

cat("\nANALIZA LIMMA ZAKONCZONA!\n")
cat("Wyniki zapisane w:", output_dir, "\n")

sessionInfo()
