#!/bin/sh
#SBATCH --job-name=vcf_merge
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/vcf_merge.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/vcf_merge.%A_%a.err

bcftools concat /home/jl430796/MaizePop/data/raw/imputed/chr1_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr2_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr3_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr4_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr5_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr6_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr7_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr8_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr9_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr10_imputed.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/raw/imputed/chr_all_imputed.vcf.gz

