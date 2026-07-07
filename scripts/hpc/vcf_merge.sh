#!/bin/bash
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

bcftools concat /home/jl430796/MaizePop/data/raw/admix_vcf/chr1_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr2_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr3_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr4_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr5_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr6_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr7_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr8_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr9_maf005_miss025.vcf.gz \
/home/jl430796/MaizePop/data/raw/admix_vcf/chr10_maf005_miss025.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/raw/admix_vcf/chr_all.vcf.gz

