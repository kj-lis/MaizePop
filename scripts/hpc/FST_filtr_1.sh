#!/bin/bash
#SBATCH --job-name=FST_filtr
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/FST_filtr.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/FST_filtr.%A_%a.err
#SBATCH --array=0-4

populations=("Parviglumis_Tropical" "Tropical_Iodent_1" "Tropical_SS_1" "Iodent_1vs2" "SS_1vs2")

pop=${populations[$SLURM_ARRAY_TASK_ID]}

plink --bfile /home/jl430796/MaizePop/data/processed/00_SNP/chr_all_plink \
--keep /home/jl430796/MaizePop/metadane/03_FST/${pop}_IDs.txt \
--make-bed --out /home/jl430796/MaizePop/data/processed/03_FST/${pop}_FST

