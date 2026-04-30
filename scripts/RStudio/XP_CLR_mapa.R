library(data.table)

normalize_chr <- function(x) {
  chr <- gsub("[^0-9]", "", as.character(x))
  chr <- sub("^0+", "", chr)
  chr[chr == ""] <- NA_character_
  chr
}

genetic_map <- fread(
  "/home/kuba/Desktop/finemap_v5.bed",
  col.names = c(
    "chrom_raw", "start_bp", "end_bp",
    "start_morgan", "end_morgan", "recomb_rate"
  )
)

# finemap_v5.bed is reported as Morgan, but values are often on a cM scale.
# Auto-convert to Morgan when the chromosome span is implausibly large.
if (max(genetic_map$end_morgan, na.rm = TRUE) > 10) {
  genetic_map[, `:=`(
    start_morgan = start_morgan / 100,
    end_morgan = end_morgan / 100
  )]
  message("Converted genetic map distances from cM to Morgan (divided by 100).")
}

bim_file <- Sys.getenv("BIM_FILE", "data/processed/Plink_262/imputed.bim")

snp_map <- fread(
  bim_file,
  col.names = c("chr_raw", "snp_name", "bp", "ref", "alt"),
  select = c(1, 2, 4, 5, 6)
)

genetic_map[, chr := normalize_chr(chrom_raw)]
snp_map[, chr := normalize_chr(chr_raw)]

genetic_map <- genetic_map[!is.na(chr)]
snp_map <- snp_map[!is.na(chr)]

setorder(genetic_map, chr, start_bp, end_bp)
setorder(snp_map, chr, bp)

output_dir <- "data/processed/GenetiMap"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

chromosomes <- unique(snp_map$chr)
chromosomes <- chromosomes[order(as.integer(chromosomes), na.last = TRUE)]

for (chr_id in chromosomes) {
  map_chr <- genetic_map[chr == chr_id]
  snp_chr <- snp_map[chr == chr_id]

  if (nrow(map_chr) == 0L) {
    warning(sprintf("Skipping chr%s: no intervals in finemap_v5.bed", chr_id))
    next
  }

  # Piecewise linear interpolation: use interval boundaries as breakpoints.
  x <- c(map_chr$start_bp[1], map_chr$end_bp)
  y <- c(map_chr$start_morgan[1], map_chr$end_morgan)

  snp_chr[, genetic_morgan := approx(
    x = x,
    y = y,
    xout = bp,
    method = "linear",
    ties = "ordered",
    rule = 2
  )$y]

  out_chr <- snp_chr[, .(
    SNPName = snp_name,
    `chr#` = chr,
    `GeneticDistance(Morgan)` = genetic_morgan,
    `PhysicalDistance(bp)` = bp,
    RefAllele = ref,
    TheOtherAllele = alt
  )]

  out_file <- file.path(output_dir, sprintf("chr%s.snp", chr_id))
  fwrite(out_chr, out_file, sep = "\t", col.names = FALSE, quote = FALSE)
  message(sprintf("Saved %s (%d SNPs)", out_file, nrow(out_chr)))
}
