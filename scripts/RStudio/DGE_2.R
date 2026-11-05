
# ============================================================
# ANALIZA MASHR: CONDITION + ERA
# ============================================================

# PAKIETY

library(edgeR)
library(limma)
library(mashr)

# ============================================================
# 1. SCIEZKI DO PLIKOW
# ============================================================

project_dir <- "/home/kuba/Desktop/DGE"

limma_dir <- file.path(
  project_dir,
  "results_limma"
)

output_dir_mashr <- file.path(
  project_dir,
  "results_mashr"
)

dir.create(
  output_dir_mashr,
  recursive = TRUE,
  showWarnings = FALSE
)

limma_rds <- file.path(
  limma_dir,
  "limma_objects.rds"
)

stopifnot(file.exists(limma_rds))

cat("Folder wynikow mashr:\n")
print(output_dir_mashr)

# ============================================================
# 2. WCZYTANIE OBIEKTOW Z LIMMA
# ============================================================

limma_objects <- readRDS(limma_rds)

metadata <- limma_objects$metadata
counts <- limma_objects$counts

stopifnot(
  !is.null(metadata),
  !is.null(counts)
)

cat("\nLiczba genow przed filtrowaniem:\n")
print(nrow(counts))

cat("\nLiczba probek:\n")
print(ncol(counts))

cat("\nPierwsze wiersze metadata:\n")
print(head(metadata))

cat("\nPierwsze wiersze counts:\n")
print(head(counts))

# ============================================================
# 3. PRZYGOTOWANIE METADATA
# ============================================================

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

metadata$ID <- factor(
  trimws(as.character(metadata$ID))
)

metadata$condition <- factor(
  trimws(as.character(metadata$condition)),
  levels = c("control", "cold", "chilling")
)

metadata$era <- trimws(
  as.character(metadata$era)
)

metadata$era[
  is.na(metadata$era) | metadata$era == ""
] <- "Unknown"

metadata$era <- factor(
  metadata$era,
  levels = c("I", "II", "Unknown")
)

stopifnot(
  !anyNA(metadata$sample),
  !anyNA(metadata$ID),
  !anyNA(metadata$condition),
  !anyNA(metadata$era),
  !anyDuplicated(metadata$sample),
  identical(colnames(counts), metadata$sample)
)

cat("\nLiczba wszystkich probek:\n")
print(nrow(metadata))

cat("\nLiczba probek wedlug condition:\n")
print(table(metadata$condition))

cat("\nLiczba probek wedlug era:\n")
print(table(metadata$era, useNA = "always"))

cat("\nTabela era x condition:\n")
print(table(metadata$era, metadata$condition))

cat("\nTabela ID x condition:\n")
print(table(metadata$ID, metadata$condition))

cat("\nPierwsze wiersze metadata:\n")
print(head(metadata))

stopifnot(
  nrow(metadata) == ncol(counts)
)

cat("\nMetadata przygotowane poprawnie.\n")

# ============================================================
# 4. MODEL CONDITION + ERA
# ============================================================

design_mash <- model.matrix(
  ~ condition + era,
  data = metadata
)

cat("\nKolumny modelu:\n")
print(colnames(design_mash))

cat("\nPierwsze wiersze modelu:\n")
print(head(design_mash))

if (qr(design_mash)$rank < ncol(design_mash)) {
  stop("Model condition + era nie ma pelnego rzedu.")
}

residual_df <- nrow(design_mash) - qr(design_mash)$rank

cat(
  "\nResidual degrees of freedom:",
  residual_df, "\n"
)

if (residual_df <= 0) {
  stop("Brak stopni swobody resztowych.")
}

write.csv(
  design_mash,
  file.path(output_dir_mashr, "design_condition_era.csv")
)

# ============================================================
# 5. FILTROWANIE GENOW
# ============================================================

dge_mash <- DGEList(
  counts = counts
)

keep_mash <- filterByExpr(
  dge_mash,
  design = design_mash
)

cat(
  "\nGeny przed filtrowaniem:",
  nrow(dge_mash), "\n"
)

cat(
  "Geny po filtrowaniu:",
  sum(keep_mash), "\n"
)

if (sum(keep_mash) < 2) {
  stop("Zbyt malo genow po filtrowaniu.")
}

dge_mash <- dge_mash[
  keep_mash,
  ,
  keep.lib.sizes = FALSE
]

# ============================================================
# 6. NORMALIZACJA TMM
# ============================================================

dge_mash <- calcNormFactors(
  dge_mash,
  method = "TMM"
)

logCPM_mash <- cpm(
  dge_mash,
  log = TRUE,
  prior.count = 2
)

write.csv(
  logCPM_mash,
  file.path(output_dir_mashr, "logCPM_mashr.csv")
)

# ============================================================
# 7. VOOM - WSTEPNE WAGI
# ============================================================

# Pierwsze voom potrzebne do oszacowania
# korelacji pomiarow tego samego ID.

v_initial <- voom(
  dge_mash,
  design_mash,
  plot = FALSE
)

# ============================================================
# 8. KORELACJA POWTARZANYCH POMIAROW
# ============================================================

# ID jest blokiem powtarzanych pomiarow.
# Nie dodajemy ID jako efektu stalego,
# poniewaz era jest przypisana do ID.

corfit <- duplicateCorrelation(
  v_initial,
  design = design_mash,
  block = metadata$ID
)

rho <- corfit$consensus.correlation

cat("\nKorelacja pomiarow w ramach ID:\n")
print(rho)

if (!is.finite(rho)) {
  stop("Nie udalo sie oszacowac korelacji ID.")
}

write.csv(
  data.frame(consensus_correlation = rho),
  file.path(output_dir_mashr, "duplicate_correlation.csv"),
  row.names = FALSE
)

# ============================================================
# 9. VOOM Z UWZGLEDNIENIEM KORELACJI
# ============================================================

pdf(
  file.path(output_dir_mashr, "voom_plot_mashr.pdf")
)

v_mash <- voom(
  dge_mash,
  design_mash,
  block = metadata$ID,
  correlation = rho,
  plot = TRUE
)

dev.off()

# ============================================================
# 10. DOPASOWANIE MODELU LIMMA
# ============================================================

fit_mash <- lmFit(
  v_mash,
  design_mash,
  block = metadata$ID,
  correlation = rho
)

fit_mash_ebayes <- eBayes(
  fit_mash
)

cat("\nWspolczynniki modelu:\n")
print(colnames(fit_mash$coefficients))

# ============================================================
# 11. WYCIAGNIECIE COEFFICIENTS I SE
# ============================================================

# Wszystkie wspolczynniki modelu:
# intercept, condition i era.

Bhat_all <- fit_mash$coefficients

# Niemoderowane SE z modelu limma.
# To one beda wejsciem do mashr.

Shat_all <- sweep(
  fit_mash$stdev.unscaled,
  1,
  fit_mash$sigma,
  FUN = "*"
)

stopifnot(
  identical(dim(Bhat_all), dim(Shat_all))
)

cat("\nPierwsze coefficients:\n")
print(head(Bhat_all))

cat("\nPierwsze standard errors:\n")
print(head(Shat_all))

write.csv(
  Bhat_all,
  file.path(output_dir_mashr, "coefficients_all.csv")
)

write.csv(
  Shat_all,
  file.path(output_dir_mashr, "standard_errors_all.csv")
)

# ============================================================
# 12. WYBOR EFEKTOW CONDITION DO MASHR
# ============================================================

condition_coefs <- c(
  "conditioncold",
  "conditionchilling"
)

stopifnot(
  all(condition_coefs %in% colnames(Bhat_all))
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
  identical(rownames(Bhat), rownames(Shat)),
  all(is.finite(Bhat)),
  all(is.finite(Shat)),
  all(Shat > 0)
)

cat("\nWymiary Bhat:\n")
print(dim(Bhat))

cat("\nWymiary Shat:\n")
print(dim(Shat))

cat("\nPierwsze Bhat:\n")
print(head(Bhat))

cat("\nPierwsze Shat:\n")
print(head(Shat))

write.csv(
  Bhat,
  file.path(output_dir_mashr, "Bhat_condition.csv")
)

write.csv(
  Shat,
  file.path(output_dir_mashr, "Shat_condition.csv")
)

# ============================================================
# 13. WYNIKI LIMMA DLA MODELU CONDITION + ERA
# ============================================================

results_cold_mash <- topTable(
  fit_mash_ebayes,
  coef = "conditioncold",
  number = Inf,
  adjust.method = "BH"
)

results_chilling_mash <- topTable(
  fit_mash_ebayes,
  coef = "conditionchilling",
  number = Inf,
  adjust.method = "BH"
)

write.csv(
  results_cold_mash,
  file.path(output_dir_mashr, "limma_cold_vs_control.csv")
)

write.csv(
  results_chilling_mash,
  file.path(output_dir_mashr, "limma_chilling_vs_control.csv")
)

cat("\nDEG limma cold vs control:\n")
print(sum(results_cold_mash$adj.P.Val < 0.05, na.rm = TRUE))

cat("\nDEG limma chilling vs control:\n")
print(sum(results_chilling_mash$adj.P.Val < 0.05, na.rm = TRUE))

# ============================================================
# 14. PRZYBLIZONA KORELACJA BLEDOW
# ============================================================

# Dwa efekty condition korzystaja ze wspolnej
# grupy referencyjnej: control.
#
# Przyblizamy korelacje bledow na podstawie
# macierzy modelu i korelacji wewnatrz ID.
#
# Jest to wspolna macierz V.
# Nie uwzglednia roznic wag voom miedzy genami.

n_samples <- nrow(metadata)

R <- diag(n_samples)

same_ID <- outer(
  as.character(metadata$ID),
  as.character(metadata$ID),
  FUN = "=="
)

R[same_ID] <- rho
diag(R) <- 1

# Macierz kowariancji wspolczynnikow GLS
R_inv_X <- solve(
  R,
  design_mash
)

cov_beta <- solve(
  crossprod(design_mash, R_inv_X)
)

cov_condition <- cov_beta[
  condition_coefs,
  condition_coefs,
  drop = FALSE
]

V <- cov2cor(cov_condition)

cat("\nMacierz korelacji bledow V:\n")
print(V)

stopifnot(
  all(is.finite(V)),
  all(eigen(V, symmetric = TRUE)$values > 0)
)

write.csv(
  V,
  file.path(output_dir_mashr, "error_correlation_V.csv")
)

# ============================================================
# 15. PRZYGOTOWANIE DANYCH MASHR
# ============================================================

mash_data <- mash_set_data(
  Bhat = Bhat,
  Shat = Shat,
  V = V
)

cat("\nDane do mashr przygotowane.\n")

# ============================================================
# 16. MACIERZE KOWARIANCJI EFEKTOW
# ============================================================

U_canonical <- cov_canonical(
  mash_data
)

cat("\nLiczba macierzy kowariancji:\n")
print(length(U_canonical))

# ============================================================
# 17. DOPASOWANIE MASHR
# ============================================================

mash_fit <- mash(
  mash_data,
  Ulist = U_canonical
)

cat("\nAnaliza mashr zakonczona.\n")

# ============================================================
# 18. POSTERIOR MEAN, SD I LFSR
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

cat("\nPosterior mean:\n")
print(head(posterior_mean))

cat("\nPosterior SD:\n")
print(head(posterior_sd))

cat("\nLFSR:\n")
print(head(lfsr))

write.csv(
  posterior_mean,
  file.path(output_dir_mashr, "posterior_mean.csv")
)

write.csv(
  posterior_sd,
  file.path(output_dir_mashr, "posterior_sd.csv")
)

write.csv(
  lfsr,
  file.path(output_dir_mashr, "lfsr.csv")
)

# ============================================================
# 19. ZESTAWIENIE WYNIKOW DLA GENOW
# ============================================================

mash_results <- data.frame(
  gene = rownames(Bhat),
  
  Bhat_cold = Bhat[, "conditioncold"],
  SE_cold = Shat[, "conditioncold"],
  posterior_cold = posterior_mean[, "conditioncold"],
  posterior_SD_cold = posterior_sd[, "conditioncold"],
  lfsr_cold = lfsr[, "conditioncold"],
  
  Bhat_chilling = Bhat[, "conditionchilling"],
  SE_chilling = Shat[, "conditionchilling"],
  posterior_chilling = posterior_mean[, "conditionchilling"],
  posterior_SD_chilling = posterior_sd[, "conditionchilling"],
  lfsr_chilling = lfsr[, "conditionchilling"],
  
  row.names = NULL
)

# ============================================================
# 20. IDENTYFIKACJA GENOW Z EFEKTAMI
# ============================================================

lfsr_threshold <- 0.05

mash_results$significant_cold <- (
  mash_results$lfsr_cold < lfsr_threshold
)

mash_results$significant_chilling <- (
  mash_results$lfsr_chilling < lfsr_threshold
)

# Kierunek efektu
mash_results$direction_cold <- ifelse(
  mash_results$posterior_cold > 0,
  "up",
  "down"
)

mash_results$direction_chilling <- ifelse(
  mash_results$posterior_chilling > 0,
  "up",
  "down"
)

# Klasyfikacja genow
mash_results$response <- "none"

mash_results$response[
  mash_results$significant_cold &
    !mash_results$significant_chilling
] <- "cold_only"

mash_results$response[
  !mash_results$significant_cold &
    mash_results$significant_chilling
] <- "chilling_only"

mash_results$response[
  mash_results$significant_cold &
    mash_results$significant_chilling
] <- "both"

cat("\nLiczba genow wedlug odpowiedzi:\n")
print(table(mash_results$response))

cat("\nPierwsze wyniki:\n")
print(head(mash_results))

write.csv(
  mash_results,
  file.path(output_dir_mashr, "mashr_gene_results.csv"),
  row.names = FALSE
)

# ============================================================
# 21. ZAPIS GENOW Z WIARYGODNYMI EFEKTAMI
# ============================================================

significant_genes <- subset(
  mash_results,
  significant_cold | significant_chilling
)

cold_genes <- subset(
  mash_results,
  significant_cold
)

chilling_genes <- subset(
  mash_results,
  significant_chilling
)

both_genes <- subset(
  mash_results,
  significant_cold & significant_chilling
)

write.csv(
  significant_genes,
  file.path(output_dir_mashr, "mashr_significant_genes.csv"),
  row.names = FALSE
)

write.csv(
  cold_genes,
  file.path(output_dir_mashr, "mashr_cold_genes.csv"),
  row.names = FALSE
)

write.csv(
  chilling_genes,
  file.path(output_dir_mashr, "mashr_chilling_genes.csv"),
  row.names = FALSE
)

write.csv(
  both_genes,
  file.path(output_dir_mashr, "mashr_both_genes.csv"),
  row.names = FALSE
)

# ============================================================
# 22. PODSUMOWANIE
# ============================================================

summary_mashr <- data.frame(
  category = c(
    "cold",
    "chilling",
    "both",
    "cold_only",
    "chilling_only"
  ),
  
  n_genes = c(
    nrow(cold_genes),
    nrow(chilling_genes),
    nrow(both_genes),
    sum(mash_results$response == "cold_only"),
    sum(mash_results$response == "chilling_only")
  )
)

cat("\nPodsumowanie mashr:\n")
print(summary_mashr)

write.csv(
  summary_mashr,
  file.path(output_dir_mashr, "mashr_summary.csv"),
  row.names = FALSE
)

# ============================================================
# 23. ZAPIS OBIEKTOW R
# ============================================================

saveRDS(
  list(
    metadata = metadata,
    counts = counts,
    design = design_mash,
    dge = dge_mash,
    voom = v_mash,
    correlation = rho,
    fit = fit_mash,
    fit_ebayes = fit_mash_ebayes,
    Bhat_all = Bhat_all,
    Shat_all = Shat_all,
    Bhat = Bhat,
    Shat = Shat,
    V = V,
    mash_fit = mash_fit,
    posterior_mean = posterior_mean,
    posterior_sd = posterior_sd,
    lfsr = lfsr,
    results = mash_results
  ),
  file.path(output_dir_mashr, "mashr_objects.rds")
)

# ============================================================
# 24. KONIEC ANALIZY
# ============================================================

cat("\n========================================\n")
cat("ANALIZA MASHR ZAKONCZONA\n")
cat("========================================\n")

cat("\nWyniki zapisano w:\n")
print(output_dir_mashr)

cat("\nLiczba genow z efektem cold:",
    nrow(cold_genes), "\n")

cat("Liczba genow z efektem chilling:",
    nrow(chilling_genes), "\n")

cat("Liczba genow z efektem w obu warunkach:",
    nrow(both_genes), "\n")
