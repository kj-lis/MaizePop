#!/bin/sh
#SBATCH --job-name=zea_LD_9
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zea_LD_9.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zea_LD_9.%A_%a.err
#SBATCH --array=1-5

LD=${SLURM_ARRAY_TASK_ID}

/home/jl430796/PopLDdecay/bin/PopLDdecay \
-InVCF /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD${LD}.vcf.gz \
-OutStat /home/jl430796/MaizePop/results/full/zea_LD/zea_${LD}_LD -MaxDist 500 -MAF 0.05