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

bcftools concat /home/jl430796/MaizePop/data/raw/inputed/chr1_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr2_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr3_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr4_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr5_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr6_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr7_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr8_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr9_inputed.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed/chr10_inputed.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/raw/inputed/chr_all_inputed.vcf.gz

