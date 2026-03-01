#!/bin/sh
#SBATCH --job-name=zea_fst_13
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zea_fst_13.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zea_fst_13.%A_%a.err

vcf="/home/jl430796/MaizePop/data/processed/zea_fst/chr_zea_fst_all.vcf.gz"
subpops=("/home/jl430796/MaizePop/metadane/pop1.txt" "/home/jl430796/MaizePop/metadane/pop2.txt" \
"/home/jl430796/MaizePop/metadane/pop3.txt" "/home/jl430796/MaizePop/metadane/pop4.txt" \
"/home/jl430796/MaizePop/metadane/pop5.txt")

n=${#subpops[@]}

for ((i=0; i<$n; i++)); do
  for ((j=i+1; j<$n; j++)); do
    pop1=${subpops[$i]}
    pop2=${subpops[$j]}
    
    p1name=$(basename $pop1 .txt)
    p2name=$(basename $pop2 .txt)
    outname="fst_${p1name}_${p2name}"
    
    echo "Liczenie FST dla $p1 i $pop2 -> $outname"
    
    vcftools --gzvcf $vcf \
             --weir-fst-pop $pop1 \
             --weir-fst-pop $pop2 \
             --out $outname
  done
done


########################


library(data.table)

ids <- fread("pop1_single_col.txt", header=FALSE)
ids2col <- data.table(V1 = ids$V1, V2 = ids$V1)  # powielamy IID jako FID
fwrite(ids2col, "pop1.txt", sep=" ", col.names=FALSE)