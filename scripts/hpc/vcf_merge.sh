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

bcftools concat /home/jl430796/MaizePop/data/raw/imputed/chr1_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr2_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr3_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr4_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr5_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr6_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr7_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr8_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr9_fixed.vcf.gz \
/home/jl430796/MaizePop/data/raw/imputed/chr10_fixed.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/raw/imputed/chr_all_imputed.vcf.gz

