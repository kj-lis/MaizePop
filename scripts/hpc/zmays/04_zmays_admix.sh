#!/bin/sh
#SBATCH --job-name=zmays_admix_4
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_admix_4.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_admix_4.%A_%a.err

for K in {2..10}; do
    admixture /home/jl430796/MaizePop/data/processed/zmays/PCA/chr_all_zmays_plink_3.bed $K
done