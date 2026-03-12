#!/bin/sh
#SBATCH --job-name=zmays_14
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_14.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_14.%A_%a.err

plink --bfile /home/jl430796/MaizePop/data/processed/00_SNP_odfiltr/chr_all_zea_plink_3 \
--keep /home/jl430796/MaizePop/metadane/05_fixation_index/Parviglumis_Tropical_IDs.txt \
--make-bed --out /home/jl430796/MaizePop/results/full/04_fixation_index/zea_Parviglumis_Tropical