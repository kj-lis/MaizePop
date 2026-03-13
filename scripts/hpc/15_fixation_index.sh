#!/bin/sh
#SBATCH --job-name=zmays_15
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_15.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_15.%A_%a.err

/home/jl430796/software/gcta-1.95.1-linux-x86_64/gcta64 \
        --bfile /home/jl430796/MaizePop/data/processed/04_fixation_index/zea_Parviglumis_Tropical \
        --fst \
        --sub-popu /home/jl430796/MaizePop/metadane/05_fixation_index/Parviglumis_Tropical_fst_IDs.txt \
        --out /home/jl430796/MaizePop/data/processed/04_fixation_index/Parviglumis_Tropical_fst