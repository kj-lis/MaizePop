#!/bin/sh
#SBATCH --job-name=zall_bcf_2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/maize_pop.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/maize_pop.%A_%a.err

bcftools concat /home/jl430796/MaizePop/data/processed/zea_all/chr_1_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_2_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_3_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_4_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_5_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_6_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_7_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_8_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_9_zea_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_all/chr_10_zea_MAF_F.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_all/chr_zea_all.vcf.gz