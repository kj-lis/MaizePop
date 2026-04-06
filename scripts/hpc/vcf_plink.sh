#!/bin/bash
#SBATCH --job-name=vcf_plink
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/vcf_plink.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/vcf_plink.%A_%a.err

plink --vcf /home/jl430796/MaizePop/data/raw/imputed/chr_all_imputed.vcf.gz \
--make-bed --biallelic-only strict --double-id \
--out /home/jl430796/MaizePop/data/processed/00_SNP/chr_all_plink

