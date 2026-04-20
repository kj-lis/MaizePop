#!/bin/bash
#SBATCH --job-name=FST_filtr_2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/FST_filtr_2.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/FST_filtr_2.%A_%a.err
#SBATCH --array=0-5

populations=("Iodent_1_SS_1" "Iodent_2_SS_2" "Iodent_1_NSS" "Iodent_2_NSS" "SS_1_NSS" "SS_2_NSS")

pop=${populations[$SLURM_ARRAY_TASK_ID]}

plink --bfile /home/jl430796/MaizePop/data/processed/00_SNP/chr_all_plink \
--keep /home/jl430796/MaizePop/metadane/03_FST/${pop}_IDs.txt \
--make-bed --out /home/jl430796/MaizePop/data/processed/03_FST/${pop}_FST

