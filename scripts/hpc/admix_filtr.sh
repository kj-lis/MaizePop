#!/bin/bash
#SBATCH --job-name=admix_filtr
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/admix_filtr.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/admix_filtr.%A_%a.err

plink --bfile /home/jl430796/MaizePop/data/processed/00_SNP/chr_all \
--indep-pairwise 50 5 0.2 \
--out /home/jl430796/MaizePop/data/processed/01_admix/chr_all_admix_1

plink --bfile /home/jl430796/MaizePop/data/processed/00_SNP/chr_all \
--extract /home/jl430796/MaizePop/data/processed/01_admix/chr_all_admix_1.prune.in \
--make-bed \
--out /home/jl430796/MaizePop/data/processed/01_admix/chr_all_admix_2

