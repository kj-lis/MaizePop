#!/bin/sh
#SBATCH --job-name=zmays_11
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_11.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_11.%A_%a.err
#SBATCH --array=1-7

LD=${SLURM_ARRAY_TASK_ID}

bcftools view -S /home/jl430796/MaizePop/metadane/04_admix/zea_LD${LD}_IDs.txt /home/jl430796/MaizePop/data/raw/chr_all_zea_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/03_LDdecay/zea_LD${LD}.vcf.gz