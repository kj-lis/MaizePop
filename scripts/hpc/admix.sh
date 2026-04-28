#!/bin/bash
#SBATCH --job-name=admix
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/admix.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/admix.%A_%a.err

for K in {2..15}; do
    admixture --cv /home/jl430796/MaizePop/data/processed/01_admix/chr_all_admix_2.bed $K \
    > log${K}.txt
done

