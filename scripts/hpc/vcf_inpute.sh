#!/bin/sh
#SBATCH --job-name=vcf_inpute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=45G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/vcf_inpute.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/vcf_inpute.%A_%a.err

for i in {1..10}; do
  java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar \
    gt=/home/jl430796/MaizePop/data/raw/vcf_current/chr${i}_maf005_miss025.vcf.gz \
    out=/home/jl430796/MaizePop/data/raw/inputed/chr${i}_inputed
done

