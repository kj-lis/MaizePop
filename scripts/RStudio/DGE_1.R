# ============================================================
# ANALIZA DGE: KALLISTO + LIMMA (ID + condition)
# ============================================================

# PAKIETY

library(tximport)
library(edgeR)
library(limma)
library(ggplot2)
library(pheatmap)

# ============================================================
# 2. SCIEZKI DO PLIKOW
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
# 3. WCZYTANIE METADANYCH
# ============================================================

metadata <- read.csv(
  metadata_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# Sprawdzenie wymaganych kolumn
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
metadata$ID <- trimws(metadata$ID)
metadata$condition <- trimws(metadata$condition)
metadata$era <- trimws(metadata$era)

stopifnot(
  !anyNA(metadata[, required_cols]),
  !anyDuplicated(metadata$sample),
  all(nzchar(metadata$sample)),
  all(nzchar(metadata$ID))
)

# Ustawienie zmiennych
metadata$condition <- factor(
  metadata$condition,
  levels = c("control", "cold", "chilling")
)

metadata$ID <- factor(metadata$ID)
metadata$era <- factor(metadata$era)

stopifnot(!anyNA(metadata$condition))

# Podglad danych
head(metadata)

# Liczba probek w warunkach
table(metadata$condition)

# Liczba probek wedlug era
table(metadata$era, metadata$condition)

# Sprawdzenie ukladu genotypow
table(metadata$ID, metadata$condition)


# ============================================================
# 4. AUTOMATYCZNE WYKRYWANIE FOLDEROW KALLISTO
# ============================================================

# Przykladowe foldery:
# 2FACC_control/
# 2FACC_cold/
# 2FACC_chilling/
# 78004_control/
# 78004_cold/
# 78004_chilling/

sample_dirs <- list.dirs(
  kallisto_dir,
  recursive = FALSE,
  full.names = TRUE
)

sample_ids <- basename(sample_dirs)

# Kazdy folder zawiera abundance.tsv
files <- file.path(
  sample_dirs,
  "abundance.tsv"
)

names(files) <- sample_ids

# Kontrola obecnosci plikow
if (!all(file.exists(files))) {
  stop(
    "Brak abundance.tsv w folderach: ",
    paste(
      sample_ids[!file.exists(files)],
      collapse = ", "
    )
  )
}

# Kontrola zgodnosci z metadanymi
missing_samples <- setdiff(
  metadata$sample,
  names(files)
)

extra_samples <- setdiff(
  names(files),
  metadata$sample
)

if (length(missing_samples) > 0) {
  stop(
    "Brak wynikow kallisto dla: ",
    paste(missing_samples, collapse = ", ")
  )
}

if (length(extra_samples) > 0) {
  warning(
    "Dodatkowe foldery, nieobecne w metadanych: ",
    paste(extra_samples, collapse = ", ")
  )
}

# Uporzadkowanie zgodnie z metadanymi
files <- files[metadata$sample]

stopifnot(
  all(file.exists(files)),
  identical(names(files), metadata$sample)
)

print(files)


# ============================================================
# 5. AUTOMATYCZNE TWORZENIE TX2GENE
# ============================================================

# Przyklad:
# Zm00001eb033650_T002 -> Zm00001eb033650

example_abundance <- read.delim(
  files[1],
  stringsAsFactors = FALSE
)

stopifnot(
  "target_id" %in% colnames(example_abundance)
)

transcript_ids <- example_abundance$target_id

# Sprawdzenie formatu identyfikatorow
valid_ids <- grepl(
  "_T[0-9]+$",
  transcript_ids
)

if (!all(valid_ids)) {
  stop(
    "Nie wszystkie identyfikatory pasuja do _T001. ",
    "Sprawdz nazwy transkryptow."
  )
}

stopifnot(!anyDuplicated(transcript_ids))

# Usuniecie koncowki transkryptu
gene_ids <- sub(
  "_T[0-9]+$",
  "",
  transcript_ids
)

tx2gene <- data.frame(
  TXNAME = transcript_ids,
  GENEID = gene_ids
)

# Kontrola identyfikatorow w pozostalych probkach
for (f in files[-1]) {
  ids <- read.delim(
    f,
    stringsAsFactors = FALSE
  )$target_id
  
  if (!setequal(ids, transcript_ids)) {
    stop(
      "Niezgodne identyfikatory transkryptow: ",
      f
    )
  }
}

# Podglad
head(tx2gene)

cat(
  "Liczba transkryptow:",
  nrow(tx2gene), "\n"
)

cat(
  "Liczba unikalnych genow:",
  length(unique(tx2gene$GENEID)), "\n"
)

# Zapis mapowania
write.csv(
  tx2gene,
  file.path(output_dir, "tx2gene_generated.csv"),
  row.names = FALSE
)


# ============================================================
# 6. IMPORT KALLISTO NA POZIOMIE GENOW
# ============================================================

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

cat(
  "Liczba genow:",
  nrow(counts), "\n"
)

cat(
  "Liczba probek:",
  ncol(counts), "\n"
)

head(counts)

# Zapis macierzy
write.csv(
  counts,
  file.path(output_dir, "gene_counts.csv")
)


# ============================================================
# 7. PRZYGOTOWANIE MODELU LIMMA
# ============================================================

# Model uwzglednia genotyp oraz warunek
design <- model.matrix(
  ~ ID + condition,
  data = metadata
)

print(colnames(design))

# Sprawdzenie pelnego rzedu
if (qr(design)$rank < ncol(design)) {
  stop(
    "Model nie ma pelnego rzedu. ",
    "Sprawdz uklad ID i condition."
  )
}

# Sprawdzenie stopni swobody
residual_df <- nrow(design) - qr(design)$rank

cat(
  "Residual degrees of freedom:",
  residual_df, "\n"
)

if (residual_df <= 0) {
  stop("Brak stopni swobody resztowych.")
}


# ============================================================
# 8. FILTROWANIE GENOW
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
# 9. NORMALIZACJA TMM
# ============================================================

dge <- calcNormFactors(
  dge,
  method = "TMM"
)

# Znormalizowane logCPM
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
# 10. VOOM
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
# 11. LIMMA - DOPASOWANIE MODELU
# ============================================================

fit <- lmFit(
  v,
  design
)


# ============================================================
# 12. KONTRASTY
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
# 13. WYNIKI LIMMA
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
# 14. IDENTYFIKACJA DEG
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
# 15. COEFFICIENTS I STANDARD ERRORS
# ============================================================

# Log2 fold changes dla kontrastow
Bhat <- fit_contrasts$coefficients

# Niemoderowane standard errors
Shat <- sweep(
  fit_contrasts$stdev.unscaled,
  1,
  fit_contrasts$sigma,
  FUN = "*"
)

stopifnot(
  identical(dim(Bhat), dim(Shat))
)

# Zapis do dalszej analizy mashr
write.csv(
  Bhat,
  file.path(output_dir, "coefficients.csv")
)

write.csv(
  Shat,
  file.path(output_dir, "standard_errors.csv")
)


# ============================================================
# 16. ZAPIS WYNIKOW DEG
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
# 17. PCA
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
# 18. VOLCANO PLOTS
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
# 19. HEATMAPA
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
# 20. ZAPIS OBIEKTOW R
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
# 21. PODSUMOWANIE
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
