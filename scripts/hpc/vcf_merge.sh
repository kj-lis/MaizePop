#!/bin/bash
#SBATCH --job-name=vcf_merge_1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/vcf_merge_1.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/vcf_merge_1.%A_%a.err

bcftools concat /home/jl430796/MaizePop/data/raw/vcf_Ania/chr1_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr2_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr3_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr4_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr5_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr6_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr7_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr8_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr9_imputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/vcf_Ania/chr10_imputed.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/raw/vcf_Ania/chr_all_imputed.vcf.gz

