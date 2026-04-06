#!/bin/bash
#SBATCH --job-name=vcf_merge_2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/vcf_merge_2.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/vcf_merge_2.%A_%a.err

bcftools concat /home/jl430796/MaizePop/data/raw/vcf_current/chr1_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr2_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr3_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr4_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr5_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr6_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr7_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr8_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr9_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_current/chr10_maf005_miss025.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/raw/vcf_current/chr_all_maf005_miss025.vcf.gz

