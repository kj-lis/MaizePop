#!/bin/sh
#SBATCH --job-name=zmays_1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_1.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_1.%A_%a.err
#SBATCH --array=1-10

chr=${SLURM_ARRAY_TASK_ID}

bcftools view /home/jl430796/MaizePop/data/raw/chr_${chr}_zea.vcf.gz -i 'F_MISSING<0.2 && MAF>=0.05' -m2 -M2 -v snps \
-O z -o /home/jl430796/MaizePop/data/raw/chr_${chr}_filtr.vcf.gz