#!/bin/sh
#SBATCH --job-name=zmmp_bcf_6
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmmp_bcf_6.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmmp_bcf_6.%A_%a.err

bcftools concat /home/jl430796/MaizePop/data/processed/zea_mmp/chr_1_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_2_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_3_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_4_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_5_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_6_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_7_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_8_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_9_zea_mmp_MAF_F.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_mmp/chr_10_zea_mmp_MAF_F.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_mmp/chr_zea_mmp_all.vcf.gz
