#!/bin/bash
#SBATCH --job-name=XP_EHH_hap
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH_hap.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH_hap.%A_%a.err
#SBATCH --array=1-10

chr=${SLURM_ARRAY_TASK_ID}

INPUT_DIR=/home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH
OUTPUT_DIR=/home/jl430796/MaizePop/data/processed/04_XP_EHH/3_XP_EHH

populations=("Parviglumis" "Tropical" "Iodent_1" "Iodent_2" "SS_1" "SS_2")

for pop in "${populations[@]}"; do

    echo "Processing chr${chr} ${pop}"

    bcftools query -f '[%GT\t]\n' \
    ${INPUT_DIR}/chr${chr}_${pop}.vcf.gz | \
    awk '
    {
        for(i=1; i<=NF; i++) {
            split($i,a,"|");
            h1[i]=h1[i]" "a[1];
            h2[i]=h2[i]" "a[2];
        }
    }
    END {
        for(i=1; i<=NF; i++) {
            print substr(h1[i],2);
            print substr(h2[i],2);
        }
    }' > ${OUTPUT_DIR}/chr${chr}_${pop}.hap

done

