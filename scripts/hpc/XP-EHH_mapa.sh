#!/bin/bash
#SBATCH --job-name=XP_EHH_mapa
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH_mapa.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH_mapa.%A_%a.err

for chr in {1..10}; do

    awk -v c=$chr '$1==c {
    print $1, $2, $4/1000000, $4 
    }' /home/jl430796/MaizePop/data/processed/00_SNPs/chr_all_plink.bim \
    > /home/jl430796/MaizePop/data/processed/04_XP_EHH/2_XP_EHH/chr${chr}.map

done