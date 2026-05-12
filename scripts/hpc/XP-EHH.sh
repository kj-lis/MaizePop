#!/bin/bash
#SBATCH --job-name=XP_EHH
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH.%A_%a.err
#SBATCH --array=1-10

chr=${SLURM_ARRAY_TASK_ID}

/home/jl430796/software/selscan/bin/linux/selscan \
  --xpehh \
  --hap ${OUTPUT_DIR}/chr${chr}_Tropical.hap \
  --ref ${OUTPUT_DIR}/chr${chr}_Parviglumis.hap \
  --map ${OUTPUT_DIR}/chr${chr}.map \
  --out ${OUTPUT_DIR}/chr${chr}_Pv_Tr

