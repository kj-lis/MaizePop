#!/bin/bash
#SBATCH --job-name=XP_CLR_geno
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=24:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_CLR_geno.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_CLR_geno.%A_%a.err
#SBATCH --array=1-10

chr=${SLURM_ARRAY_TASK_ID}

INPUT_DIR=/home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH
OUTPUT_DIR=/home/jl430796/MaizePop/data/processed/05_XP_CLR

populations=("Parviglumis" "Tropical" "Iodent_1" "Iodent_2" "SS_1" "SS_2")

for pop in "${populations[@]}"; do

    bcftools query -f '[%GT\t]\n' \
    ${INPUT_DIR}/chr${chr}_${pop}.vcf.gz | \
    awk '
    {
        for(i=1; i<=NF; i++) {

            if($i=="./." || $i==".|.") {
                printf "9 9"
            }

            else {

                gsub(/\|/, "/", $i)

                split($i,a,"/")

                printf a[1]" "a[2]
            }

            if(i<NF) {
                printf " "
            }
        }

        printf "\n"
    }' > ${OUTPUT_DIR}/chr${chr}_${pop}.geno

done