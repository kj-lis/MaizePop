#!/bin/bash
#SBATCH --job-name=XP_EHH_filtr
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH_filtr.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH_filtr.%A_%a.err
#SBATCH --array=1-10

set -euo pipefail

chr=${SLURM_ARRAY_TASK_ID}
populations=("Parviglumis" "Tropical" "Iodent_1" "Iodent_2" "SS_1" "SS_2")

for pop in "${populations[@]}"; do
    bcftools view \
        -S /home/jl430796/MaizePop/metadane/04_XP_EHH/${pop}.txt \
        /home/jl430796/MaizePop/data/raw/imputed/chr${chr}_fixed.vcf.gz \
        -O z -o /home/jl430796/MaizePop/data/processed/04_XP_EHH/chr${chr}_${pop}.vcf.gz
done

