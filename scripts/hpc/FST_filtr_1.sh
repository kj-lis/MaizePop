#!/bin/sh
#SBATCH --job-name=fst_1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/fst_1.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/fst_1.%A_%a.err

bcftools concat /home/jl430796/MaizePop/data/raw/inputed_chr_1.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_2.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_3.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_4.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_5.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_6.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_7.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_8.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_9.vcf.gz \
/home/jl430796/MaizePop/data/raw/inputed_chr_10.vcf.gz \
-O z -o /home/jl430796/MaizePop/data/processed/00/chr_all_zea_filtr.vcf.gz


java -Xmx45g -jar /home/jl430796/software/beagle.27Feb25.75f.jar gt=chr_1_zea.vcf.gz out=inputed_chr_1 nthreads=12