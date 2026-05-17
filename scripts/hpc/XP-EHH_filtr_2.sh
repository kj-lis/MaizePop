#!/bin/bash
#SBATCH --job-name=XP_EHH_filtr_2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH_filtr_2.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH_filtr_2.%A_%a.err
#SBATCH --array=1-10

set -euo pipefail

chr=${SLURM_ARRAY_TASK_ID}
populations=("Parviglumis" "Tropical" "Iodent_1" "Iodent_2" "SS_1" "SS_2")

for pop in "${populations[@]}"; do
    plink --vcf /home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH/chr${chr}_${pop}.vcf.gz \
          --make-bed --biallelic-only strict --double-id \
          --out /home/jl430796/MaizePop/data/processed/04_XP_EHH/2_XP_EHH/chr${chr}_${pop}
done

