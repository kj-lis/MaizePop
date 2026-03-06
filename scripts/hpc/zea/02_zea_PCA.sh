#!/bin/sh
#SBATCH --job-name=zea_PCA_2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zea_PCA_2.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zea_PCA_2.%A_%a.err

bcftools concat /home/jl430796/MaizePop/data/processed/zea_PCA/chr_1_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_2_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_3_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_4_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_5_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_6_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_7_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_8_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_9_zea_filtr.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_PCA/chr_10_zea_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_PCA/chr_all_zea_filtr.vcf.gz