#!/bin/sh
#SBATCH --job-name=vcf_inpute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/vcf_inpute.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/vcf_inpute.%A_%a.err
#SBATCH --array=1-10

#zrobić z tego pętle


java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar 
gt=chr1_maf005_miss025.vcf.gz 
out=chr1_inputed

