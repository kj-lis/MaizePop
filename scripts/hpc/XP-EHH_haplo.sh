#!/bin/bash
#SBATCH --job-name=XP_EHH_haplo
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH_haplo.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH_haplo.%A_%a.err
#SBATCH --array=1-10

chr=${SLURM_ARRAY_TASK_ID}

INPUT_DIR=/home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH
OUTPUT_DIR=/home/jl430796/MaizePop/data/processed/04_XP_EHH/2_XP_EHH

############################################
# 1. Remove duplicate positions
############################################

bcftools query -f '%CHROM\t%POS\n' \
${INPUT_DIR}/chr${chr}_Parviglumis.vcf.gz | \
awk '!seen[$1":"$2]++' > ${OUTPUT_DIR}/chr${chr}_unique_sites.txt

bcftools view \
-T ${OUTPUT_DIR}/chr${chr}_unique_sites.txt \
${INPUT_DIR}/chr${chr}_Parviglumis.vcf.gz \
-Oz -o ${OUTPUT_DIR}/chr${chr}_Parviglumis.clean.vcf.gz

bcftools view \
-T ${OUTPUT_DIR}/chr${chr}_unique_sites.txt \
${INPUT_DIR}/chr${chr}_Tropical.vcf.gz \
-Oz -o ${OUTPUT_DIR}/chr${chr}_Tropical.clean.vcf.gz

############################################
# 2. Create HAP files
############################################

# Subpopulation 2

bcftools query -f '[%GT\t]\n' \
${OUTPUT_DIR}/chr${chr}_Parviglumis.clean.vcf.gz | \
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
}' > ${OUTPUT_DIR}/chr${chr}_Parviglumis.hap

# Subopulation 2

bcftools query -f '[%GT\t]\n' \
${OUTPUT_DIR}/chr${chr}_Tropical.clean.vcf.gz | \
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
}' > ${OUTPUT_DIR}/chr${chr}_Tropical.hap

############################################
# 3. Create MAP file
############################################

bcftools query -f '%CHROM\t%ID\t%POS\n' \
${OUTPUT_DIR}/chr${chr}_Parviglumis.clean.vcf.gz | \
awk '{print $1, $2, $3/1000000, $3}' \
> ${OUTPUT_DIR}/chr${chr}.map

