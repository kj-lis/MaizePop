# ============================================================
# ANALIZA DGE: MASHR WITH COMMON BASELINE
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
  "results_mashr_common_baseline"
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

# ============================================================
# 2. METADANE
# ============================================================

metadata <- read.csv2(
  metadata_file,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

colnames(metadata) <- trimws(colnames(metadata))

required_cols <- c(
  "sample",
  "ID",
  "condition",
  "group"
)

stopifnot(
  all(required_cols %in% names(metadata))
)

for (nm in required_cols) {
  metadata[[nm]] <- trimws(
    as.character(metadata[[nm]])
  )
}

stopifnot(
  !anyNA(metadata$sample),
  !anyNA(metadata$ID),
  !anyNA(metadata$condition),
  !anyNA(metadata$group),
  !any(metadata$sample == ""),
  !any(metadata$ID == ""),
  !any(metadata$group == ""),
  !anyDuplicated(metadata$sample)
)

groups <- c(
  "Tropical",
  "Iodent",
  "Landrace",
  "Mexicana",
  "mix",
  "NSS",
  "Parviglumis",
  "SS"
)

conditions <- c(
  "control",
  "cold",
  "chilling"
)

stopifnot(
  all(metadata$group %in% groups),
  all(metadata$condition %in% conditions)
)

metadata$group <- factor(
  metadata$group,
  levels = groups
)

metadata$condition <- factor(
  metadata$condition,
  levels = conditions
)

metadata$ID <- factor(metadata$ID)

cat("\nLiczba probek:\n")
print(nrow(metadata))

cat("\nPopulacje:\n")
print(table(metadata$group))

cat("\nPopulacja x condition:\n")

group_condition_table <- table(
  metadata$group,
  metadata$condition
)

print(group_condition_table)

write.csv(
  as.data.frame.matrix(group_condition_table),
  file.path(
    output_dir,
    "group_condition_counts.csv"
  )
)

if (any(group_condition_table == 0)) {
  stop(
    "Brakuje przynajmniej jednej kombinacji ",
    "group x condition. Sprawdz ",
    "group_condition_counts.csv."
  )
}

group_per_ID <- tapply(
  as.character(metadata$group),
  metadata$ID,
  function(x) length(unique(x))
)

if (any(group_per_ID != 1)) {
  stop(
    "Niektore ID wystepuja w wielu populacjach. ",
    "Sprawdz metadane."
  )
}

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

if (any(!file.exists(files))) {
  stop(
    "Brak plikow kallisto:\n",
    paste(
      files[!file.exists(files)],
      collapse = "\n"
    )
  )
}

# ============================================================
# 4. TRANSCRIPT-TO-GENE
# ============================================================

transcript_ids <- as.character(
  rhdf5::h5read(
    files[1],
    "aux/ids"
  )
)

tx2gene <- data.frame(
  TXNAME = transcript_ids,
  GENEID = sub(
    "_T[0-9]+$",
    "",
    transcript_ids
  )
)

stopifnot(
  !anyDuplicated(tx2gene$TXNAME)
)

write.csv(
  tx2gene,
  file.path(output_dir, "tx2gene.csv"),
  row.names = FALSE
)

# ============================================================
# 5. IMPORT TXIMPORT
# ============================================================

cat("\nImport danych kallisto...\n")

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
  all(is.finite(counts)),
  all(counts >= 0)
)

write.csv(
  counts,
  file.path(
    output_dir,
    "counts_all_genes.csv"
  )
)

# ============================================================
# 6. MODEL Z INTERAKCJA
# ============================================================

design <- model.matrix(
  ~ group * condition,
  data = metadata
)

rownames(design) <- metadata$sample

if (qr(design)$rank != ncol(design)) {
  stop(
    "Macierz modelu nie ma pelnego rzedu."
  )
}

cat("\nWspolczynniki modelu:\n")
print(colnames(design))

write.csv(
  design,
  file.path(
    output_dir,
    "design_matrix.csv"
  )
)

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

cat("\nGeny przed filtrowaniem: ",
    nrow(dge), "\n")

cat("Geny po filtrowaniu: ",
    sum(keep), "\n")

if (sum(keep) < 2) {
  stop("Za malo genow po filtrowaniu.")
}

write.csv(
  data.frame(
    gene = rownames(dge),
    retained = as.logical(keep)
  ),
  file.path(
    output_dir,
    "gene_filtering_results.csv"
  ),
  row.names = FALSE
)

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

write.csv(
  dge$samples,
  file.path(
    output_dir,
    "normalization_factors.csv"
  )
)

write.csv(
  dge$counts,
  file.path(
    output_dir,
    "counts_filtered.csv"
  )
)

# ============================================================
# 9. VOOM + DUPLICATE CORRELATION
# ============================================================

v_initial <- voom(
  dge,
  design,
  plot = FALSE
)

corfit <- duplicateCorrelation(
  v_initial,
  design = design,
  block = metadata$ID
)

rho <- corfit$consensus.correlation

stopifnot(
  length(rho) == 1,
  is.finite(rho)
)

cat("\nKorelacja wewnatrz ID:\n")
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

pdf(
  file.path(
    output_dir,
    "voom_mean_variance.pdf"
  ),
  width = 8,
  height = 6
)

v <- voom(
  dge,
  design = design,
  block = metadata$ID,
  correlation = rho,
  plot = TRUE
)

dev.off()

write.csv(
  v$E,
  file.path(
    output_dir,
    "voom_logCPM.csv"
  )
)

# ============================================================
# 10. LIMMA
# ============================================================

fit <- lmFit(
  v,
  design,
  block = metadata$ID,
  correlation = rho
)

fit <- eBayes(fit)


# ============================================================
# 11. KONTRASTY COMMON BASELINE
# ============================================================

other_groups <- setdiff(
  groups,
  "Tropical"
)

stresses <- c(
  "cold",
  "chilling"
)

contrast_names <- character()
coefficient_names <- character()

for (stress in stresses) {
  
  for (pop in other_groups) {
    
    contrast_names <- c(
      contrast_names,
      paste0(
        stress,
        "_",
        pop,
        "_vs_Tropical"
      )
    )
    
    coefficient_names <- c(
      coefficient_names,
      paste0(
        "group",
        pop,
        ":condition",
        stress
      )
    )
  }
}

if (!all(
  coefficient_names %in% colnames(design)
)) {
  stop(
    "Nie znaleziono wspolczynnikow interakcji:\n",
    paste(
      setdiff(
        coefficient_names,
        colnames(design)
      ),
      collapse = "\n"
    )
  )
}

contrast_matrix <- matrix(
  0,
  nrow = ncol(design),
  ncol = length(contrast_names),
  dimnames = list(
    colnames(design),
    contrast_names
  )
)

for (j in seq_along(contrast_names)) {
  contrast_matrix[
    coefficient_names[j],
    j
  ] <- 1
}

write.csv(
  contrast_matrix,
  file.path(
    output_dir,
    "contrast_matrix.csv"
  )
)

fit_contrasts <- contrasts.fit(
  fit,
  contrasts = contrast_matrix
)

fit_contrasts <- eBayes(
  fit_contrasts
)

# ============================================================
# 12. WYNIKI LIMMA DLA 14 KONTRASTOW
# ============================================================

limma_summary <- data.frame(
  contrast = contrast_names,
  DEG_FDR005 = NA_integer_,
  Up = NA_integer_,
  Down = NA_integer_
)

for (j in seq_along(contrast_names)) {
  
  contrast_name <- contrast_names[j]
  
  tt <- topTable(
    fit_contrasts,
    coef = j,
    number = Inf,
    adjust.method = "BH",
    sort.by = "P"
  )
  
  tt$gene <- rownames(tt)
  
  write.csv(
    tt,
    file.path(
      output_dir,
      paste0(
        "limma_",
        contrast_name,
        "_all.csv"
      )
    ),
    row.names = FALSE
  )
  
  sig <- !is.na(tt$adj.P.Val) &
    tt$adj.P.Val < 0.05
  
  limma_summary$DEG_FDR005[j] <-
    sum(sig)
  
  limma_summary$Up[j] <-
    sum(sig & tt$logFC > 0)
  
  limma_summary$Down[j] <-
    sum(sig & tt$logFC < 0)
  
  write.csv(
    tt[sig, , drop = FALSE],
    file.path(
      output_dir,
      paste0(
        "limma_",
        contrast_name,
        "_DEG.csv"
      )
    ),
    row.names = FALSE
  )
}

write.csv(
  limma_summary,
  file.path(
    output_dir,
    "limma_DEG_summary.csv"
  ),
  row.names = FALSE
)

# ============================================================
# 13. BHAT I SHAT
# ============================================================

Bhat <- fit_contrasts$coefficients

Shat <- sweep(
  fit_contrasts$stdev.unscaled,
  1,
  fit_contrasts$sigma,
  "*"
)

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

# ============================================================
# 14. MACIERZ KORELACJI BLEDOW - V
# ============================================================

n <- nrow(metadata)

R <- diag(n)

same_ID <- outer(
  as.character(metadata$ID),
  as.character(metadata$ID),
  "=="
)

R[same_ID] <- rho

diag(R) <- 1

chol(R)

R_inv_design <- solve(
  R,
  design
)

cov_beta <- solve(
  crossprod(
    design,
    R_inv_design
  )
)

cov_contrasts <- t(contrast_matrix) %*%
  cov_beta %*%
  contrast_matrix

V <- cov2cor(
  cov_contrasts
)

chol(V)

write.csv(
  V,
  file.path(
    output_dir,
    "mashr_error_correlation_V.csv"
  )
)

cat("\nMacierz V:\n")
print(round(V, 3))

# ============================================================
# 15. MASHR - DANE
# ============================================================

mash_data <- mash_set_data(
  Bhat = Bhat,
  Shat = Shat,
  V = V
)

# ============================================================
# 16. MASHR - KOWARIANCJE
# ============================================================

U_canonical <- cov_canonical(
  mash_data
)

# ============================================================
# 17. MASHR - DOPASOWANIE
# ============================================================

cat("\nDopasowanie mashr...\n")

mash_fit <- mash(
  mash_data,
  Ulist = U_canonical
)

cat("\nMashr zakonczony.\n")

# ============================================================
# 18. WYNIKI POSTERIOR
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
# 19. WYNIKI ZBIORCZE MASHR
# ============================================================

mash_results <- data.frame(
  gene = rownames(Bhat),
  stringsAsFactors = FALSE
)

for (cn in colnames(Bhat)) {
  
  mash_results[
    [paste0(cn, "_Bhat")]
  ] <- Bhat[, cn]
  
  mash_results[
    [paste0(cn, "_SE")]
  ] <- Shat[, cn]
  
  mash_results[
    [paste0(cn, "_posterior_mean")]
  ] <- posterior_mean[, cn]
  
  mash_results[
    [paste0(cn, "_posterior_sd")]
  ] <- posterior_sd[, cn]
  
  mash_results[
    [paste0(cn, "_lfsr")]
  ] <- lfsr[, cn]
}

mash_results$min_lfsr <- apply(
  lfsr,
  1,
  min
)

mash_results$significant_any <- apply(
  lfsr < 0.05,
  1,
  any
)

write.csv(
  mash_results,
  file.path(
    output_dir,
    "mashr_all_genes.csv"
  ),
  row.names = FALSE
)

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

# ============================================================
# 20. OSOBNE WYNIKI DLA KAZDEGO KONTRASTU
# ============================================================

mash_summary <- data.frame(
  contrast = colnames(lfsr),
  genes_lfsr005 = colSums(
    lfsr < 0.05
  )
)

for (cn in colnames(lfsr)) {
  
  result <- data.frame(
    gene = rownames(Bhat),
    Bhat = Bhat[, cn],
    SE = Shat[, cn],
    posterior_mean = posterior_mean[, cn],
    posterior_sd = posterior_sd[, cn],
    lfsr = lfsr[, cn],
    significant = lfsr[, cn] < 0.05
  )
  
  result <- result[
    order(result$lfsr),
    ,
    drop = FALSE
  ]
  
  write.csv(
    result,
    file.path(
      output_dir,
      paste0(
        "mashr_",
        cn,
        "_all.csv"
      )
    ),
    row.names = FALSE
  )
  
  write.csv(
    result[
      result$significant,
      ,
      drop = FALSE
    ],
    file.path(
      output_dir,
      paste0(
        "mashr_",
        cn,
        "_significant.csv"
      )
    ),
    row.names = FALSE
  )
}

write.csv(
  mash_summary,
  file.path(
    output_dir,
    "mashr_summary.csv"
  ),
  row.names = FALSE
)

cat("\nPodsumowanie mashr:\n")
print(mash_summary)

# ============================================================
# 21. PCA
# ============================================================

pca <- prcomp(
  t(v$E),
  center = TRUE,
  scale. = FALSE
)

variance <- 100 *
  pca$sdev^2 /
  sum(pca$sdev^2)

pca_df <- data.frame(
  sample = metadata$sample,
  group = metadata$group,
  condition = metadata$condition,
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

p <- ggplot(
  pca_df,
  aes(
    PC1,
    PC2,
    color = group,
    shape = condition
  )
) +
  geom_point(
    alpha = 0.7,
    size = 2
  ) +
  theme_bw() +
  labs(
    title = "PCA - population and stress",
    x = paste0(
      "PC1 (",
      round(variance[1], 1),
      "%)"
    ),
    y = paste0(
      "PC2 (",
      round(variance[2], 1),
      "%)"
    )
  )

ggsave(
  file.path(
    output_dir,
    "PCA_group_condition.png"
  ),
  p,
  width = 10,
  height = 7,
  dpi = 300
)

# ============================================================
# 22. HEATMAP EFEKTOW MASHR
# ============================================================

significant_genes <- names(
  which(
    apply(
      lfsr < 0.05,
      1,
      any
    )
  )
)

if (length(significant_genes) >= 2) {
  
  gene_rank <- sort(
    apply(
      lfsr[
        significant_genes,
        ,
        drop = FALSE
      ],
      1,
      min
    )
  )
  
  selected_genes <- head(
    names(gene_rank),
    50
  )
  
  heatmap_matrix <- posterior_mean[
    selected_genes,
    ,
    drop = FALSE
  ]
  
  png(
    file.path(
      output_dir,
      "heatmap_mashr_top50_effects.png"
    ),
    width = 1600,
    height = 1200,
    res = 150
  )
  
  pheatmap(
    heatmap_matrix,
    scale = "none",
    cluster_rows = TRUE,
    cluster_cols = TRUE,
    main = paste(
      "Mashr posterior effects",
      "- Tropical baseline"
    )
  )
  
  dev.off()
}

# ============================================================
# 23. ZAPIS OBIEKTOW RDS
# ============================================================

saveRDS(
  list(
    metadata = metadata,
    tx2gene = tx2gene,
    counts = counts,
    design = design,
    dge = dge,
    voom = v,
    correlation = corfit,
    rho = rho,
    fit = fit,
    contrast_matrix = contrast_matrix,
    fit_contrasts = fit_contrasts,
    Bhat = Bhat,
    Shat = Shat,
    V = V
  ),
  file.path(
    output_dir,
    "limma_common_baseline_objects.rds"
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
    "mashr_common_baseline_objects.rds"
  )
)

# ============================================================
# 24. INFORMACJE O SESJI
# ============================================================

capture.output(
  sessionInfo(),
  file = file.path(
    output_dir,
    "sessionInfo.txt"
  )
)

# ============================================================
# 25. KONIEC
# ============================================================

cat("\n====================================\n")
cat("ANALIZA ZAKONCZONA\n")
cat("====================================\n")

cat("\nLiczba probek:\n")
print(nrow(metadata))

cat("\nLiczba genow:\n")
print(nrow(Bhat))

cat("\nLiczba kontrastow:\n")
print(ncol(Bhat))

cat("\nConsensus correlation:\n")
print(rho)

cat("\nLimma DEG:\n")
print(limma_summary)

cat("\nMashr:\n")
print(mash_summary)

cat("\nFolder wynikowy:\n")
print(output_dir)
