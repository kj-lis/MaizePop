#!/bin/bash
#SBATCH --job-name=XP_EHH_norm
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH_norm.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH_norm.%A_%a.err
#SBATCH --array=1-10

chr=${SLURM_ARRAY_TASK_ID}

/home/jl430796/software/selscan/bin/linux/selscan \
  norm 
  --xpehh 
  --files /home/jl430796/MaizePop/results/full/04_XP_EHH/1_XP_EHH/chr${chr}_Pv_Tr.xpehh.out 
  --bp-win