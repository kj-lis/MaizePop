#!/bin/sh
#SBATCH --job-name=zmays_bcf_5_1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_bcf_5.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_bcf_5.%A_%a.err

chr=${SLURM_ARRAY_TASK_ID}

bcftools view -S /home/jl430796/MaizePop/metadane/1_IDs.txt /home/marcing/DATA/VCF/chr_${chr}_filtered_raw.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_${chr}_zea_LD_1.vcf.gz

bcftools view /home/jl430796/MaizePop/data/processed/zea_LD/chr_${chr}_zea_LD_1.vcf.gz -i 'F_MISSING<0.2 && MAF>=0.05' -m2 -M2 -v snps \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_${chr}_zea_filtr_LD_1.vcf.gz

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
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_filtr_LD_1_all.vcf.gz