#!/bin/sh
#SBATCH --job-name=zmays_bcf_5
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_bcf_5.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_bcf_5.%A_%a.err

bcftools view -S /home/jl430796/MaizePop/metadane/1_IDs.txt /home/jl430796/MaizePop/data/processed/zea_mays/chr_zea_mays_all_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD1.vcf.gz

bcftools view -S /home/jl430796/MaizePop/metadane/2_IDs.txt /home/jl430796/MaizePop/data/processed/zea_mays/chr_zea_mays_all_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD2.vcf.gz

bcftools view -S /home/jl430796/MaizePop/metadane/3_IDs.txt /home/jl430796/MaizePop/data/processed/zea_mays/chr_zea_mays_all_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD3.vcf.gz

bcftools view -S /home/jl430796/MaizePop/metadane/4_IDs.txt /home/jl430796/MaizePop/data/processed/zea_mays/chr_zea_mays_all_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD4.vcf.gz

bcftools view -S /home/jl430796/MaizePop/metadane/5_IDs.txt /home/jl430796/MaizePop/data/processed/zea_mays/chr_zea_mays_all_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD5.vcf.gz