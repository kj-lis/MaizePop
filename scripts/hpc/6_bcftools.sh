#!/bin/sh
#SBATCH --job-name=zmmp_bcf_6_1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmmp_bcf_6.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmmp_bcf_6.%A_%a.err

bcftools concat /home/jl430796/MaizePop/data/processed/zea_LD/chr_1_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_2_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_3_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_4_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_5_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_6_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_7_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_8_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_9_zea_filtr_LD_1.vcf.gz \
/home/jl430796/MaizePop/data/processed/zea_LD/chr_10_zea_filtr_LD_1.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_all_filtr_LD_1.vcf.gz
