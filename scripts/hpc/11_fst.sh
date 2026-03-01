#!/bin/sh
#SBATCH --job-name=zea_fst_11
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zea_fst_11.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zea_fst_11.%A_%a.err

plink --vcf /home/jl430796/MaizePop/data/processed/zea_mays/chr_zea_mays_all_filtr.vcf.gz --make-bed --biallelic-only strict --double-id \
--out /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all_plink_1

plink --bfile /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all_plink_1 --indep-pairwise 50 5 0.2 \
--out /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all_plink_2

plink --bfile /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all_plink_1 \
--extract /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all_plink_2.prune.in --make-bed \
--out /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all_plink_3