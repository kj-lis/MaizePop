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

/home/jl430796/software/selscan/bin/linux/selscan \
  --xpehh \
  --vcf /home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH/chr1_Tropical.vcf.gz \
  --vcf-ref /home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH/chr1_Parviglumis.vcf.gz \
  --map /home/jl430796/MaizePop/data/processed/04_XP_EHH/1_XP_EHH/chr1.map \
  --out /home/jl430796/MaizePop/data/processed/04_XP_EHH/2_XP_EHH/chr1_Trop_vs_Parv