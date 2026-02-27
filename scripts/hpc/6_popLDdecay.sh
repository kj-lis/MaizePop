#!/bin/sh
#SBATCH --job-name=zmays_LD_6
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_LD_6.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_LD_6.%A_%a.err

PopLDdecay -InVCF /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD1.vcf.gz -OutStat zea_1_LD -MaxDist 500
PopLDdecay -InVCF /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD1.vcf.gz -OutStat zea_2_LD -MaxDist 500
PopLDdecay -InVCF /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD1.vcf.gz -OutStat zea_3_LD -MaxDist 500
PopLDdecay -InVCF /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD1.vcf.gz -OutStat zea_4_LD -MaxDist 500
PopLDdecay -InVCF /home/jl430796/MaizePop/data/processed/zea_LD/chr_zea_mays_LD1.vcf.gz -OutStat group1 -MaxDist 500