#!/bin/sh
#SBATCH --job-name=zea_fst_11_5
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zea_fst_11_5.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zea_fst_11_5.%A_%a.err

plink --bfile /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all_plink_3 --chr 1 --make-bed \
--out  /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_chr1