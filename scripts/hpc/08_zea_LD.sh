#!/bin/sh
#SBATCH --job-name=zea_LD_8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zea_LD_8.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zea_LD_8.%A_%a.err
#SBATCH --array=1-5

LD=${SLURM_ARRAY_TASK_ID}

bcftools view -S /home/jl430796/MaizePop/metadane/LDdecay/${LD}_IDs.txt /home/jl430796/MaizePop/data/processed/zea_mays/chr_zea_mays_all_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD${LD}.vcf.gz