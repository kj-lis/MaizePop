# ============================================================
# ANALIZA DGE: KALLISTO + LIMMA (ID + condition)
# ============================================================

# PAKIETY

library(tximport)
library(edgeR)
library(limma)
library(ggplot2)
library(pheatmap)
library(rhdf5)

# ============================================================
# 1. SCIEZKI
# ============================================================

project_dir <- "/home/kuba/Desktop/DGE"

kallisto_dir <- file.path(project_dir, "DGE_kallisto")
metadata_file <- file.path(project_dir, "DGE_metadane/DGE_metadane.csv")

output_dir <- file.path(project_dir, "results_limma")

dir.create(
  output_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

stopifnot(dir.exists(kallisto_dir))
stopifnot(file.exists(metadata_file))

# ============================================================
# 2. METADANE
# ============================================================

metadata <- read.csv2(
  metadata_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

colnames(metadata) <- trimws(colnames(metadata))

colnames(metadata)
head(metadata)

required_cols <- c(
  "sample",
  "condition",
  "ID",
  "era"
)

stopifnot(
  all(required_cols %in% colnames(metadata))
)

metadata$sample <- trimws(metadata$sample)
metadata$ID <- factor(trimws(metadata$ID))

metadata$condition <- factor(
  trimws(metadata$condition),
  levels = c("control", "cold", "chilling")
)

metadata$era <- factor(trimws(metadata$era))

head(metadata)
table(metadata$condition)
table(metadata$era, metadata$condition)

# ============================================================
# 3. PLIKI KALLISTO
# ============================================================

sample_dirs <- list.dirs(
  kallisto_dir,
  recursive = FALSE,
  full.names = TRUE
)

sample_ids <- basename(sample_dirs)

files <- file.path(sample_dirs, "abundance.h5")
names(files) <- sample_ids

stopifnot(
  all(file.exists(files))
)

cat(
  "Probki w metadata bez plikow kallisto:\n"
)
print(setdiff(metadata$sample, names(files)))

cat(
  "Pliki kallisto bez probek w metadata:\n"
)
print(setdiff(names(files), metadata$sample))

stopifnot(
  setequal(metadata$sample, names(files))
)

files <- files[metadata$sample]

stopifnot(
  identical(names(files), metadata$sample)
)

print(files)

cat(
  "Liczba plikow H5:",
  length(files), "\n"
)

# ============================================================
# 4. TWORZENIE TX2GENE
# ============================================================

transcript_ids <- rhdf5::h5read(
  files[1],
  "aux/ids"
)

stopifnot(
  all(grepl("_T[0-9]+$", transcript_ids))
)

gene_ids <- sub(
  "_T[0-9]+$",
  "",
  transcript_ids
)

tx2gene <- data.frame(
  TXNAME = transcript_ids,
  GENEID = gene_ids,
  stringsAsFactors = FALSE
)

stopifnot(
  !anyDuplicated(tx2gene$TXNAME),
  !anyNA(tx2gene)
)

cat(
  "Liczba transkryptow:",
  nrow(tx2gene), "\n"
)

cat(
  "Liczba unikalnych genow:",
  length(unique(tx2gene$GENEID)), "\n"
)

head(tx2gene)

for (f in files[-1]) {
  
  ids <- rhdf5::h5read(
    f,
    "aux/ids"
  )
  
  if (!setequal(ids, transcript_ids)) {
    stop(
      "Niezgodne identyfikatory transkryptow w pliku: ",
      f
    )
  }
}

cat(
  "Wszystkie probki zawieraja zgodny zestaw transkryptow.\n"
)

write.csv(
  tx2gene,
  file.path(output_dir, "tx2gene.csv"),
  row.names = FALSE
)

# ============================================================
# 5. IMPORT KALLISTO NA POZIOMIE GENOW
# ============================================================

txi <- tximport(
  files = files,
  type = "kallisto",
  tx2gene = tx2gene,
  countsFromAbundance = "lengthScaledTPM",
  dropInfReps = TRUE
)

counts <- txi$counts

stopifnot(
  identical(colnames(counts), metadata$sample)
)

cat(
  "Liczba genow:",
  nrow(counts), "\n"
)

cat(
  "Liczba probek:",
  ncol(counts), "\n"
)

head(counts)

write.csv(
  counts,
  file.path(output_dir, "gene_counts.csv")
)

# ============================================================
# 6. PRZYGOTOWANIE MODELU LIMMA
# ============================================================

design <- model.matrix(
  ~ ID + condition,
  data = metadata
)

print(colnames(design))

if (qr(design)$rank < ncol(design)) {
  stop(
    "Model nie ma pelnego rzedu. ",
    "Sprawdz uklad ID i condition."
  )
}

residual_df <- nrow(design) - qr(design)$rank

cat(
  "Residual degrees of freedom:",
  residual_df, "\n"
)

if (residual_df <= 0) {
  stop("Brak stopni swobody resztowych.")
}

# ============================================================
# 7. FILTROWANIE GENOW
# ============================================================

dge <- DGEList(
  counts = counts
)

keep <- filterByExpr(
  dge,
  design = design
)

cat(
  "Geny przed filtrowaniem:",
  nrow(dge), "\n"
)

cat(
  "Geny po filtrowaniu:",
  sum(keep), "\n"
)

if (sum(keep) < 2) {
  stop("Zbyt malo genow po filtrowaniu.")
}

dge <- dge[
  keep,
  ,
  keep.lib.sizes = FALSE
]

# ============================================================
# 8. NORMALIZACJA TMM
# ============================================================

dge <- calcNormFactors(
  dge,
  method = "TMM"
)

logCPM <- cpm(
  dge,
  log = TRUE,
  prior.count = 2
)

write.csv(
  logCPM,
  file.path(output_dir, "logCPM.csv")
)

# ============================================================
# 9. VOOM
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

# ============================================================
# 10. LIMMA - DOPASOWANIE MODELU
# ============================================================

fit <- lmFit(
  v,
  design
)

# ============================================================
# 11. KONTRASTY
# ============================================================

contrast_matrix <- makeContrasts(
  
  cold_vs_control = conditioncold,
  
  chilling_vs_control = conditionchilling,
  
  cold_vs_chilling =
    conditioncold - conditionchilling,
  
  levels = design
)

fit_contrasts <- contrasts.fit(
  fit,
  contrast_matrix
)

fit_contrasts <- eBayes(
  fit_contrasts
)

# ============================================================
# 12. WYNIKI LIMMA
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
# 13. IDENTYFIKACJA DEG
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

cat(
  "DEG cold vs control:",
  nrow(deg_cold), "\n"
)

cat(
  "DEG chilling vs control:",
  nrow(deg_chilling), "\n"
)

cat(
  "DEG cold vs chilling:",
  nrow(deg_cold_chilling), "\n"
)

# ============================================================
# 14. COEFFICIENTS I STANDARD ERRORS
# ============================================================

Bhat <- fit_contrasts$coefficients

Shat <- sweep(
  fit_contrasts$stdev.unscaled,
  1,
  fit_contrasts$sigma,
  FUN = "*"
)

stopifnot(
  identical(dim(Bhat), dim(Shat))
)

write.csv(
  Bhat,
  file.path(output_dir, "coefficients.csv")
)

write.csv(
  Shat,
  file.path(output_dir, "standard_errors.csv")
)

# ============================================================
# 15. ZAPIS WYNIKOW DEG
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
  deg_cold,
  file.path(output_dir, "DEG_cold.csv")
)

write.csv(
  deg_chilling,
  file.path(output_dir, "DEG_chilling.csv")
)

write.csv(
  deg_cold_chilling,
  file.path(output_dir, "DEG_cold_chilling.csv")
)

# ============================================================
# 16. PCA
# ============================================================

pca <- prcomp(
  t(logCPM),
  center = TRUE,
  scale. = FALSE
)

pca_variance <- 100 *
  pca$sdev^2 / sum(pca$sdev^2)

pca_df <- data.frame(
  PC1 = pca$x[, 1],
  PC2 = pca$x[, 2],
  condition = metadata$condition,
  era = metadata$era,
  ID = metadata$ID
)

p_pca <- ggplot(
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
    title = "PCA - RNA-seq",
    x = paste0(
      "PC1 (",
      round(pca_variance[1], 1),
      "%)"
    ),
    y = paste0(
      "PC2 (",
      round(pca_variance[2], 1),
      "%)"
    )
  ) +
  theme_bw()

ggsave(
  file.path(output_dir, "PCA.png"),
  p_pca,
  width = 8,
  height = 6
)

# ============================================================
# 17. VOLCANO PLOTS
# ============================================================

plot_volcano <- function(results, title, filename) {
  
  df <- results
  
  df$significant <- ifelse(
    df$adj.P.Val < 0.05,
    "Significant",
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
    geom_point(
      alpha = 0.6,
      size = 1
    ) +
    scale_color_manual(
      values = c(
        "Significant" = "red",
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
# 18. HEATMAPA
# ============================================================

gene_variance <- apply(
  logCPM,
  1,
  var
)

top_genes <- names(
  sort(
    gene_variance,
    decreasing = TRUE
  )
)[1:min(50, nrow(logCPM))]

annotation <- metadata[
  ,
  c("condition", "era", "ID")
]

rownames(annotation) <- metadata$sample

pheatmap(
  logCPM[top_genes, , drop = FALSE],
  scale = "row",
  annotation_col = annotation,
  filename = file.path(
    output_dir,
    "heatmap_top50.png"
  ),
  width = 10,
  height = 9
)

# ============================================================
# 19. ZAPIS OBIEKTOW R
# ============================================================

saveRDS(
  list(
    metadata = metadata,
    tx2gene = tx2gene,
    counts = counts,
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
# 20. PODSUMOWANIE
# ============================================================

summary_table <- data.frame(
  comparison = c(
    "cold_vs_control",
    "chilling_vs_control",
    "cold_vs_chilling"
  ),
  DEG_FDR_005 = c(
    nrow(deg_cold),
    nrow(deg_chilling),
    nrow(deg_cold_chilling)
  )
)

print(summary_table)

write.csv(
  summary_table,
  file.path(output_dir, "DEG_summary.csv"),
  row.names = FALSE
)
