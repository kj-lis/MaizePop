#!/bin/sh
#SBATCH --job-name=zmays_gcta_8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_gcta_8.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_gcta_8.%A_%a.err

gcta64 --bfile /home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all_plink_3 \
       --fst \
       --sub-popu /home/jl430796/MaizePop/metadane/zea_mays_fst_metadane.txt \
       --out /home/jl430796/MaizePop/results/full/zea_fst/zea_mays_fst