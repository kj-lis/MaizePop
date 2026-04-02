#!/bin/sh
#SBATCH --job-name=xp_ehh_1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/xp_ehh_1.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/xp_ehh_1.%A_%a.err
#SBATCH --array=1-10

chr=${SLURM_ARRAY_TASK_ID}

java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar \
gt=/home/jl430796/MaizePop/data/raw/chr_${chr}_zea.vcf.gz \
out=/home/jl430796/MaizePop/data/raw/inputed_chr_${chr} \
nthreads=12
