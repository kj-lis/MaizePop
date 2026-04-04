#!/bin/bash -l
#SBATCH --job-name=vcf_subset
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/vcf_subset.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/vcf_subset.%A_%a.err
#SBATCH --array=1-10

set -euo pipefail

# Activate bcftools (installed in the "geno" conda environment)
module load common/anaconda/3.8
conda activate geno

# Inputs --------------------------------------------------------------------
INCLUDE_SAMPLES_FILE=/home/jl430796/MaizePop/metadane/linie.txt
VCF_DIR=/home/marcing/DATA/VCF
OUTPUT_DIR=/home/jl430796/MaizePop/data/raw/inputed

# Optional reference FASTA for left-alignment/normalization.
# Set REF_FASTA to the path of your reference (e.g., B73 v5) to enable
# left alignment and REF/ALT normalization via bcftools norm. When unset,
# the script will still remove duplicate variants but will skip left-alignment.
REF_FASTA=${REF_FASTA:-}

mkdir -p "${OUTPUT_DIR}"

if [[ ! -s "${INCLUDE_SAMPLES_FILE}" ]]; then
  echo "Include list missing or empty: ${INCLUDE_SAMPLES_FILE}" >&2
  exit 1
fi

CHR=$(printf "chr_%d" "${SLURM_ARRAY_TASK_ID}")
INPUT_VCF="${VCF_DIR}/${CHR}_filtered_raw.vcf.gz"
OUTPUT_VCF="${OUTPUT_DIR}/${CHR}_matched_maf05_miss025.vcf.gz"

if [[ ! -f "${INPUT_VCF}" ]]; then
  echo "Input VCF not found: ${INPUT_VCF}" >&2
  exit 1
fi

# Validate optional reference if provided
if [[ -n "${REF_FASTA}" && ! -f "${REF_FASTA}" ]]; then
  echo "Reference FASTA not found: ${REF_FASTA}" >&2
  exit 1
fi

# Filter variants after excluding non-maize samples. Keep MAF > 0.05, missing rate < 0.25,
# and only biallelic sites. Strip INFO fields and preserve only FORMAT/GT. Normalize genotype
# strings so solitary "." become "./." (diploid missing). Optionally left-align and remove
# duplicate sites to avoid downstream duplicate-marker issues.
if [[ -n "${REF_FASTA}" ]]; then
  echo "[INFO] Left-aligning with reference and removing duplicate sites"
  bcftools view \
    --samples-file "${INCLUDE_SAMPLES_FILE}" \
    --include 'MAF>0.05 && F_MISSING<0.25 && COUNT(GT="het") / COUNT(GT!="mis") <= 0.1' \
    --min-alleles 2 \
    --max-alleles 2 \
    --output-type u \
    "${INPUT_VCF}" \
    | bcftools annotate -x INFO,^FORMAT/GT \
    | awk 'BEGIN{OFS="\t"} /^#/ {print; next} {for (i=10;i<=NF;i++) if ($i==".") $i="./."; print}' \
    | bcftools norm -f "${REF_FASTA}" -Ou \
    | awk 'BEGIN{OFS="\t"} /^#/ {print; next} {key=$1 OFS $2 OFS $4 OFS $5; if (!seen[key]++) print}' \
    | bcftools view -Oz -o "${OUTPUT_VCF}"
else
  echo "[INFO] No reference provided; skipping left-alignment. Removing duplicate sites"
  bcftools view \
    --samples-file "${INCLUDE_SAMPLES_FILE}" \
    --include 'MAF>0.05 && F_MISSING<0.25 && COUNT(GT="het") / COUNT(GT!="mis") <= 0.1' \
    --min-alleles 2 \
    --max-alleles 2 \
    --output-type u \
    "${INPUT_VCF}" \
    | bcftools annotate -x INFO,^FORMAT/GT \
    | awk 'BEGIN{OFS="\t"} /^#/ {print; next} {for (i=10;i<=NF;i++) if ($i==".") $i="./."; print}' \
    | awk 'BEGIN{OFS="\t"} /^#/ {print; next} {key=$1 OFS $2 OFS $4 OFS $5; if (!seen[key]++) print}' \
    | bcftools view -Oz -o "${OUTPUT_VCF}"
fi

# Index the resulting VCF
bcftools index --force "${OUTPUT_VCF}"

