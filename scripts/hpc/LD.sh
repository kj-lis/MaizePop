#!/bin/bash
#SBATCH --job-name=LD
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/LD.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/LD.%A_%a.err
#SBATCH --array=1-7

LD=${SLURM_ARRAY_TASK_ID}

/home/jl430796/software/PopLDdecay/bin/PopLDdecay \
-InVCF /home/jl430796/MaizePop/data/processed/02_LD/1_LD/LD${LD}.vcf.gz \
-OutStat /home/jl430796/MaizePop/results/full/02_LD/1_LD/LD${LD} -MaxDist 500 -OutType 2

