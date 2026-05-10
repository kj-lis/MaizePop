#!/bin/bash
#SBATCH --job-name=XP_EHH
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/test.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/test.%A_%a.err



############################################
# 4. Run XP-EHH
############################################

/home/jl430796/software/selscan/bin/linux/selscan \
  --xpehh \
  --hap ${OUTPUT_DIR}/chr${chr}_Tropical.hap \
  --ref ${OUTPUT_DIR}/chr${chr}_Parviglumis.hap \
  --map ${OUTPUT_DIR}/chr${chr}.map \
  --threads 8 \
  --out ${OUTPUT_DIR}/chr${chr}_Trop_vs_Parv
```


bcftools query -f '%CHROM\t%POS\n' chr1_Parviglumis.vcf.gz | \
awk '{print $1"\tsnp_"$2"\t"$2"\t"$2}' > chr1.map



bcftools norm -d exact chr1_Tropical.vcf.gz -Oz -o chr1_Tropical.clean.vcf.gz
bcftools norm -d exact chr1_Parviglumis.vcf.gz -Oz -o chr1_Parviglumis.clean.vcf.gz


/home/jl430796/software/selscan/bin/linux/selscan \
  --xpehh \
  --vcf /home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH/chr1_Tropical.vcf.gz \
  --vcf-ref /home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH/chr1_Parviglumis.vcf.gz \
  --map /home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH/chr1.map \
  --out /home/jl430796/MaizePop/data/processed/04_XP_EHH/2_XP_EHH/chr1_Trop_vs_Parv