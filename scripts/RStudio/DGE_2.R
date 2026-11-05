# ============================================================
# ANALIZA DGE: MASHR (condition + era)
# ============================================================

# PAKIETY

library(tximport)
library(rhdf5)
library(edgeR)
library(limma)
library(mashr)
library(ggplot2)
library(pheatmap)

# ============================================================
# 1. SCIEZKI
# ============================================================

project_dir <- "/home/kuba/Desktop/DGE"

metadata_file <- file.path(
  project_dir,
  "DGE_metadane",
  "DGE_metadane.csv"
)

kallisto_dir <- file.path(
  project_dir,
  "DGE_kallisto"
)

output_dir <- file.path(
  project_dir,
  "results_mashr"
)

dir.create(
  output_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

stopifnot(
  file.exists(metadata_file),
  dir.exists(kallisto_dir)
)

cat("\nFolder wynikowy:\n")
print(output_dir)


# ============================================================
# 2. WCZYTANIE METADANYCH
# ============================================================

metadata <- read.csv2(
  metadata_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

colnames(metadata) <- trimws(
  colnames(metadata)
)

required_cols <- c(
  "sample",
  "condition",
  "ID",
  "era"
)

stopifnot(
  all(required_cols %in% colnames(metadata))
)

metadata$sample <- trimws(
  as.character(metadata$sample)
)

metadata$ID <- trimws(
  as.character(metadata$ID)
)

metadata$condition <- trimws(
  as.character(metadata$condition)
)

metadata$era <- trimws(
  as.character(metadata$era)
)

metadata$era[
  is.na(metadata$era) |
    metadata$era == ""
] <- "Unknown"

stopifnot(
  !anyNA(metadata$sample),
  !anyNA(metadata$ID),
  !anyNA(metadata$condition),
  !any(metadata$sample == ""),
  !any(metadata$ID == ""),
  !anyDuplicated(metadata$sample),
  all(metadata$condition %in%
        c("control", "cold", "chilling")),
  all(metadata$era %in%
        c("I", "II", "Unknown"))
)

metadata$ID <- factor(metadata$ID)

metadata$condition <- factor(
  metadata$condition,
  levels = c(
    "control",
    "cold",
    "chilling"
  )
)

metadata$era <- factor(
  metadata$era,
  levels = c(
    "I",
    "II",
    "Unknown"
  )
)

cat("\nLiczba probek:\n")
print(nrow(metadata))

cat("\nCondition:\n")
print(table(metadata$condition))

cat("\nEra:\n")
print(table(metadata$era))

cat("\nEra x condition:\n")
print(table(
  metadata$era,
  metadata$condition
))

cat("\nID x condition:\n")
print(table(
  metadata$ID,
  metadata$condition
))

write.csv(
  metadata,
  file.path(
    output_dir,
    "metadata_used.csv"
  ),
  row.names = FALSE
)

# ============================================================
# 3. PLIKI KALLISTO
# ============================================================

files <- file.path(
  kallisto_dir,
  metadata$sample,
  "abundance.h5"
)

names(files) <- metadata$sample

missing_files <- files[
  !file.exists(files)
]

if (length(missing_files) > 0) {
  stop(
    "Brakuje plikow abundance.h5:\n",
    paste(
      missing_files,
      collapse = "\n"
    )
  )
}

cat("\nLiczba plikow kallisto:\n")
print(length(files))

# ============================================================
# 4. TRANSCRIPT-TO-GENE
# ============================================================

transcript_ids <- rhdf5::h5read(
  files[1],
  "aux/ids"
)

transcript_ids <- as.character(
  transcript_ids
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
  !anyNA(tx2gene$TXNAME),
  !anyNA(tx2gene$GENEID),
  !anyDuplicated(tx2gene$TXNAME)
)

write.csv(
  tx2gene,
  file.path(
    output_dir,
    "tx2gene.csv"
  ),
  row.names = FALSE
)

# ============================================================
# 5. IMPORT KALLISTO PRZEZ TXIMPORT
# ============================================================

cat("\nImport kallisto...\n")

txi <- tximport(
  files = files,
  type = "kallisto",
  tx2gene = tx2gene,
  countsFromAbundance = "lengthScaledTPM",
  dropInfReps = TRUE
)

counts <- txi$counts

stopifnot(
  identical(
    colnames(counts),
    metadata$sample
  ),
  !anyNA(counts),
  all(is.finite(counts)),
  all(counts >= 0)
)

cat("\nWymiary macierzy counts:\n")
print(dim(counts))

write.csv(
  counts,
  file.path(
    output_dir,
    "counts_all_genes.csv"
  )
)

# ============================================================
# 6. MACIERZ MODELU
# ============================================================

design_mash <- model.matrix(
  ~ condition + era,
  data = metadata
)

rownames(design_mash) <- metadata$sample

cat("\nWspolczynniki modelu:\n")
print(colnames(design_mash))

cat("\nRzad macierzy modelu:\n")
print(qr(design_mash)$rank)

stopifnot(
  qr(design_mash)$rank ==
    ncol(design_mash)
)

write.csv(
  design_mash,
  file.path(
    output_dir,
    "design_matrix.csv"
  )
)

# ============================================================
# 7. FILTROWANIE GENOW
# ============================================================

dge_mash <- DGEList(
  counts = counts
)

keep_mash <- filterByExpr(
  dge_mash,
  design = design_mash
)

cat("\nGeny przed filtrowaniem:\n")
print(nrow(dge_mash))

cat("\nGeny po filtrowaniu:\n")
print(sum(keep_mash))

cat("\nGeny odfiltrowane:\n")
print(sum(!keep_mash))

cat("\nProcent zachowanych genow:\n")
print(round(
  100 * mean(keep_mash),
  2
))

if (sum(keep_mash) < 2) {
  stop(
    "Zbyt malo genow po filtrowaniu."
  )
}

filtering_results <- data.frame(
  gene = rownames(dge_mash),
  retained = as.logical(keep_mash)
)

write.csv(
  filtering_results,
  file.path(
    output_dir,
    "gene_filtering_results.csv"
  ),
  row.names = FALSE
)

dge_mash <- dge_mash[
  keep_mash,
  ,
  keep.lib.sizes = FALSE
]

# ============================================================
# 8. NORMALIZACJA TMM
# ============================================================

dge_mash <- calcNormFactors(
  dge_mash,
  method = "TMM"
)

normalization_info <- data.frame(
  sample = colnames(dge_mash),
  lib.size = dge_mash$samples$lib.size,
  norm.factors = dge_mash$samples$norm.factors,
  effective.lib.size =
    dge_mash$samples$lib.size *
    dge_mash$samples$norm.factors
)

write.csv(
  normalization_info,
  file.path(
    output_dir,
    "normalization_factors.csv"
  ),
  row.names = FALSE
)

write.csv(
  dge_mash$counts,
  file.path(
    output_dir,
    "counts_filtered.csv"
  )
)

# ============================================================
# 9. WSTEPNE VOOM
# ============================================================

cat("\nWstepne voom...\n")

v_initial <- voom(
  dge_mash,
  design = design_mash,
  plot = FALSE
)

# ============================================================
# 10. DUPLICATE CORRELATION
# ============================================================

cat("\nEstymacja korelacji wewnatrz ID...\n")

corfit <- duplicateCorrelation(
  v_initial,
  design = design_mash,
  block = metadata$ID
)

rho <- corfit$consensus.correlation

if (
  length(rho) != 1 ||
  !is.finite(rho)
) {
  stop(
    "Nie udalo sie oszacowac korelacji ID."
  )
}

cat("\nConsensus correlation:\n")
print(rho)

write.csv(
  data.frame(
    consensus_correlation = rho
  ),
  file.path(
    output_dir,
    "duplicateCorrelation.csv"
  ),
  row.names = FALSE
)

# ============================================================
# 11. VOOM Z KORELACJA
# ============================================================

pdf(
  file.path(
    output_dir,
    "voom_mean_variance.pdf"
  ),
  width = 8,
  height = 6
)

v_mash <- voom(
  dge_mash,
  design = design_mash,
  block = metadata$ID,
  correlation = rho,
  plot = TRUE
)

dev.off()

write.csv(
  v_mash$E,
  file.path(
    output_dir,
    "voom_logCPM.csv"
  )
)

# ============================================================
# 12. DOPASOWANIE MODELU LIMMA
# ============================================================

fit_mash <- lmFit(
  v_mash,
  design = design_mash,
  block = metadata$ID,
  correlation = rho
)

fit_mash_ebayes <- eBayes(
  fit_mash
)

cat("\nModel limma dopasowany.\n")

# ============================================================
# 13. WYNIKI LIMMA
# ============================================================

condition_coefs <- c(
  "conditioncold",
  "conditionchilling"
)

stopifnot(
  all(
    condition_coefs %in%
      colnames(fit_mash$coefficients)
  )
)

Bhat_all <- fit_mash$coefficients

Shat_all <- sweep(
  fit_mash$stdev.unscaled,
  1,
  fit_mash$sigma,
  "*"
)

Bhat <- Bhat_all[
  ,
  condition_coefs,
  drop = FALSE
]

Shat <- Shat_all[
  ,
  condition_coefs,
  drop = FALSE
]

stopifnot(
  identical(dim(Bhat), dim(Shat)),
  all(is.finite(Bhat)),
  all(is.finite(Shat)),
  all(Shat > 0)
)

write.csv(
  Bhat,
  file.path(
    output_dir,
    "mashr_input_Bhat.csv"
  )
)

write.csv(
  Shat,
  file.path(
    output_dir,
    "mashr_input_Shat.csv"
  )
)

write.csv(
  Bhat_all,
  file.path(
    output_dir,
    "limma_all_coefficients.csv"
  )
)

write.csv(
  Shat_all,
  file.path(
    output_dir,
    "limma_all_SE.csv"
  )
)

# ============================================================
# 14. KONTRASTY I DEG Z LIMMA
# ============================================================

contrast_matrix <- makeContrasts(
  cold_vs_control = conditioncold,
  chilling_vs_control = conditionchilling,
  cold_vs_chilling =
    conditioncold - conditionchilling,
  levels = design_mash
)

fit_contrasts <- contrasts.fit(
  fit_mash,
  contrast_matrix
)

fit_contrasts <- eBayes(
  fit_contrasts
)

deg_summary <- data.frame(
  contrast = colnames(contrast_matrix),
  DEG_FDR_0_05 = NA_integer_,
  Up = NA_integer_,
  Down = NA_integer_
)

for (i in seq_len(ncol(contrast_matrix))) {
  
  contrast_name <- colnames(
    contrast_matrix
  )[i]
  
  tt <- topTable(
    fit_contrasts,
    coef = contrast_name,
    number = Inf,
    adjust.method = "BH",
    sort.by = "P"
  )
  
  tt$gene <- rownames(tt)
  
  tt <- tt[
    ,
    c(
      "gene",
      setdiff(
        colnames(tt),
        "gene"
      )
    )
  ]
  
  write.csv(
    tt,
    file.path(
      output_dir,
      paste0(
        "limma_",
        contrast_name,
        "_all_genes.csv"
      )
    ),
    row.names = FALSE
  )
  
  sig <- !is.na(tt$adj.P.Val) &
    tt$adj.P.Val < 0.05
  
  deg_summary$DEG_FDR_0_05[i] <- sum(sig)
  
  deg_summary$Up[i] <- sum(
    sig & tt$logFC > 0
  )
  
  deg_summary$Down[i] <- sum(
    sig & tt$logFC < 0
  )
  
  write.csv(
    tt[sig, , drop = FALSE],
    file.path(
      output_dir,
      paste0(
        "limma_",
        contrast_name,
        "_DEG_FDR005.csv"
      )
    ),
    row.names = FALSE
  )
}

write.csv(
  deg_summary,
  file.path(
    output_dir,
    "limma_DEG_summary.csv"
  ),
  row.names = FALSE
)

print(deg_summary)

# ============================================================
# 15. KORELACJA BLEDOW ESTYMACJI - V
# ============================================================

n_samples <- nrow(metadata)

R <- diag(n_samples)

same_ID <- outer(
  as.character(metadata$ID),
  as.character(metadata$ID),
  FUN = "=="
)

R[same_ID] <- rho

diag(R) <- 1

chol(R)

R_inv_X <- solve(
  R,
  design_mash
)

cov_beta <- solve(
  crossprod(
    design_mash,
    R_inv_X
  )
)

cov_condition <- cov_beta[
  condition_coefs,
  condition_coefs,
  drop = FALSE
]

V <- cov2cor(
  cov_condition
)

stopifnot(
  all(is.finite(V))
)

chol(V)

cat("\nMacierz V:\n")
print(V)

write.csv(
  V,
  file.path(
    output_dir,
    "mashr_error_correlation_V.csv"
  )
)

# ============================================================
# 16. PRZYGOTOWANIE DANYCH MASHR
# ============================================================

mash_data <- mash_set_data(
  Bhat = Bhat,
  Shat = Shat,
  V = V
)

cat("\nDane mashr przygotowane.\n")

# ============================================================
# 17. MACIERZE KOWARIANCJI
# ============================================================

U_canonical <- cov_canonical(
  mash_data
)

cat("\nLiczba macierzy canonical:\n")
print(length(U_canonical))

# ============================================================
# 18. DOPASOWANIE MASHR
# ============================================================

cat("\nUruchamianie mashr...\n")

mash_fit <- mash(
  mash_data,
  Ulist = U_canonical
)

cat("\nAnaliza mashr zakonczona.\n")

# ============================================================
# 19. WYNIKI POSTERIOR
# ============================================================

posterior_mean <- get_pm(
  mash_fit
)

posterior_sd <- get_psd(
  mash_fit
)

lfsr <- get_lfsr(
  mash_fit
)

write.csv(
  posterior_mean,
  file.path(
    output_dir,
    "mashr_posterior_mean.csv"
  )
)

write.csv(
  posterior_sd,
  file.path(
    output_dir,
    "mashr_posterior_sd.csv"
  )
)

write.csv(
  lfsr,
  file.path(
    output_dir,
    "mashr_lfsr.csv"
  )
)

# ============================================================
# 20. TABELA ZBIORCZA MASHR
# ============================================================

genes <- rownames(Bhat)

mash_results <- data.frame(
  gene = genes,
  
  cold_Bhat =
    Bhat[, "conditioncold"],
  
  cold_SE =
    Shat[, "conditioncold"],
  
  cold_posterior_mean =
    posterior_mean[, "conditioncold"],
  
  cold_posterior_sd =
    posterior_sd[, "conditioncold"],
  
  cold_lfsr =
    lfsr[, "conditioncold"],
  
  chilling_Bhat =
    Bhat[, "conditionchilling"],
  
  chilling_SE =
    Shat[, "conditionchilling"],
  
  chilling_posterior_mean =
    posterior_mean[, "conditionchilling"],
  
  chilling_posterior_sd =
    posterior_sd[, "conditionchilling"],
  
  chilling_lfsr =
    lfsr[, "conditionchilling"],
  
  stringsAsFactors = FALSE
)

mash_results$significant_cold <-
  mash_results$cold_lfsr < 0.05

mash_results$significant_chilling <-
  mash_results$chilling_lfsr < 0.05

mash_results$significant_both <-
  mash_results$significant_cold &
  mash_results$significant_chilling

mash_results$significant_any <-
  mash_results$significant_cold |
  mash_results$significant_chilling

write.csv(
  mash_results,
  file.path(
    output_dir,
    "mashr_all_genes.csv"
  ),
  row.names = FALSE
)

# ============================================================
# 21. GENY ISTOTNE W MASHR
# ============================================================

write.csv(
  mash_results[
    mash_results$significant_any,
    ,
    drop = FALSE
  ],
  file.path(
    output_dir,
    "mashr_significant_genes.csv"
  ),
  row.names = FALSE
)

write.csv(
  mash_results[
    mash_results$significant_cold,
    ,
    drop = FALSE
  ],
  file.path(
    output_dir,
    "mashr_cold_genes.csv"
  ),
  row.names = FALSE
)

write.csv(
  mash_results[
    mash_results$significant_chilling,
    ,
    drop = FALSE
  ],
  file.path(
    output_dir,
    "mashr_chilling_genes.csv"
  ),
  row.names = FALSE
)

write.csv(
  mash_results[
    mash_results$significant_both,
    ,
    drop = FALSE
  ],
  file.path(
    output_dir,
    "mashr_both_genes.csv"
  ),
  row.names = FALSE
)

# ============================================================
# 22. PODSUMOWANIE MASHR
# ============================================================

mash_summary <- data.frame(
  comparison = c(
    "cold",
    "chilling",
    "both",
    "any"
  ),
  genes_lfsr_005 = c(
    sum(mash_results$significant_cold),
    sum(mash_results$significant_chilling),
    sum(mash_results$significant_both),
    sum(mash_results$significant_any)
  )
)

cat("\nPodsumowanie mashr:\n")
print(mash_summary)

write.csv(
  mash_summary,
  file.path(
    output_dir,
    "mashr_summary.csv"
  ),
  row.names = FALSE
)

# ============================================================
# 23. PCA
# ============================================================

cat("\nTworzenie PCA...\n")

pca <- prcomp(
  t(v_mash$E),
  center = TRUE,
  scale. = FALSE
)

variance_explained <- 100 *
  pca$sdev^2 /
  sum(pca$sdev^2)

pca_df <- data.frame(
  sample = metadata$sample,
  condition = metadata$condition,
  era = metadata$era,
  ID = metadata$ID,
  PC1 = pca$x[, 1],
  PC2 = pca$x[, 2]
)

write.csv(
  pca_df,
  file.path(
    output_dir,
    "PCA_coordinates.csv"
  ),
  row.names = FALSE
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
  geom_point(
    size = 2,
    alpha = 0.7
  ) +
  labs(
    title = "PCA - limma-voom + mashr",
    x = paste0(
      "PC1 (",
      round(variance_explained[1], 1),
      "%)"
    ),
    y = paste0(
      "PC2 (",
      round(variance_explained[2], 1),
      "%)"
    )
  ) +
  theme_bw()

ggsave(
  file.path(
    output_dir,
    "PCA_condition_era.png"
  ),
  plot = p_pca,
  width = 9,
  height = 7,
  dpi = 300
)

# ============================================================
# 24. VOLCANO PLOTS LIMMA
# ============================================================

for (
  contrast_name in
  colnames(contrast_matrix)
) {
  
  tt <- topTable(
    fit_contrasts,
    coef = contrast_name,
    number = Inf,
    sort.by = "none"
  )
  
  tt$gene <- rownames(tt)
  
  tt$significant <- (
    !is.na(tt$adj.P.Val) &
      tt$adj.P.Val < 0.05
  )
  
  tt$negLog10P <- -log10(
    pmax(
      tt$P.Value,
      .Machine$double.xmin
    )
  )
  
  p_volcano <- ggplot(
    tt,
    aes(
      x = logFC,
      y = negLog10P,
      color = significant
    )
  ) +
    geom_point(
      alpha = 0.5,
      size = 1
    ) +
    scale_color_manual(
      values = c(
        "FALSE" = "grey70",
        "TRUE" = "firebrick"
      )
    ) +
    labs(
      title = paste(
        "Limma:",
        contrast_name
      ),
      x = "log2 fold change",
      y = "-log10(p-value)"
    ) +
    theme_bw()
  
  ggsave(
    file.path(
      output_dir,
      paste0(
        "volcano_",
        contrast_name,
        ".png"
      )
    ),
    plot = p_volcano,
    width = 8,
    height = 6,
    dpi = 300
  )
}

# ============================================================
# 25. HEATMAP TOP GENOW
# ============================================================

top_genes <- mash_results[
  mash_results$significant_any,
  ,
  drop = FALSE
]

if (nrow(top_genes) >= 2) {
  
  top_genes$min_lfsr <- pmin(
    top_genes$cold_lfsr,
    top_genes$chilling_lfsr
  )
  
  top_genes <- top_genes[
    order(top_genes$min_lfsr),
    ,
    drop = FALSE
  ]
  
  selected_genes <- head(
    top_genes$gene,
    50
  )
  
  heatmap_matrix <- v_mash$E[
    selected_genes,
    ,
    drop = FALSE
  ]
  
  annotation_col <- data.frame(
    condition = metadata$condition,
    era = metadata$era
  )
  
  rownames(annotation_col) <-
    metadata$sample
  
  png(
    file.path(
      output_dir,
      "heatmap_top50_mashr.png"
    ),
    width = 1600,
    height = 1200,
    res = 150
  )
  
  pheatmap(
    heatmap_matrix,
    scale = "row",
    annotation_col = annotation_col,
    show_colnames = FALSE,
    main = "Top genes - mashr"
  )
  
  dev.off()
  
} else {
  
  cat(
    "\nZa malo istotnych genow",
    "do utworzenia heatmapy.\n"
  )
  
}

# ============================================================
# 26. ZAPIS OBIEKTOW RDS
# ============================================================

saveRDS(
  list(
    metadata = metadata,
    tx2gene = tx2gene,
    counts = counts,
    design = design_mash,
    dge = dge_mash,
    voom = v_mash,
    duplicateCorrelation = corfit,
    rho = rho,
    fit = fit_mash,
    fit_ebayes = fit_mash_ebayes,
    fit_contrasts = fit_contrasts,
    Bhat = Bhat,
    Shat = Shat,
    V = V
  ),
  file.path(
    output_dir,
    "limma_mashr_objects.rds"
  )
)

saveRDS(
  list(
    data = mash_data,
    U_canonical = U_canonical,
    fit = mash_fit,
    posterior_mean = posterior_mean,
    posterior_sd = posterior_sd,
    lfsr = lfsr,
    results = mash_results
  ),
  file.path(
    output_dir,
    "mashr_objects.rds"
  )
)


# ============================================================
# 27. INFORMACJE O SESJI
# ============================================================

capture.output(
  sessionInfo(),
  file = file.path(
    output_dir,
    "sessionInfo.txt"
  )
)

# ============================================================
# 28. KONIEC ANALIZY
# ============================================================

cat("\n========================================\n")
cat("ANALIZA ZAKONCZONA\n")
cat("========================================\n")

cat("\nLiczba probek:\n")
print(nrow(metadata))

cat("\nLiczba genow po filtrowaniu:\n")
print(nrow(dge_mash))

cat("\nKorelacja ID:\n")
print(rho)

cat("\nDEG limma:\n")
print(deg_summary)

cat("\nWyniki mashr:\n")
print(mash_summary)

cat("\nWyniki zapisano w:\n")
print(output_dir)
