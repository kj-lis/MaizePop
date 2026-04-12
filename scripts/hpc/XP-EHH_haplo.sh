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

bcftools query -f '%CHROM\t%POS[\t%GT]\n' \
/home/jl430796/MaizePop/data/processed/04_XP_EHH/XP_EHH_1/chr${chr}_Tropical.vcf.gz \
| awk '{
    for(i=3; i<=NF; i++) {
        split($i,a,"|");
        printf "%s %s ", a[1], a[2];
    }
    printf "\n";
}' > /home/jl430796/MaizePop/data/processed/04_XP_EHH/XP_EHH_2/chr${chr}_Tropical.hap

MAKE_MAP=false

if [ "$MAKE_MAP" = true ]; then
bcftools query -f '%CHROM\t%ID\t%POS\n' \
/home/jl430796/MaizePop/data/processed/04_XP_EHH/XP_EHH_1/chr${chr}_Parviglumis.vcf.gz \
| awk '{print $1, $2, $3/1000000, $3}' \
> /home/jl430796/MaizePop/data/processed/04_XP_EHH/XP_EHH_2/chr${chr}.map
fi