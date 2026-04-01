#!/bin/sh
#SBATCH --job-name=zmays_17
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_17.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_17.%A_%a.err

chr=${SLURM_ARRAY_TASK_ID}

bcftools view -S /home/jl430796/MaizePop/metadane/03_XP_EHH/Tropical.txt \
/home/jl430796/MaizePop/data/raw/chr_${chr}_zea_filtr.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/05_XP_EHH/chr_${chr}_Tropical.vcf.gz