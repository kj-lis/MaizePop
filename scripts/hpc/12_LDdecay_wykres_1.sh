#!/bin/sh
#SBATCH --job-name=zmays_13
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

Pop=${SLURM_ARRAY_TASK_ID}

perl      /home/jl430796/software/PopLDdecay/bin/Plot_OnePop.pl \
-inFile   /home/jl430796/MaizePop/results/full/zea_LD/zea_LD${Pop}.stat.gz \
-output   /home/jl430796/MaizePop/results/full/zea_LD/zea_LD${Pop}

perl  bin/Plot_MutiPop.pl  -inList  Pop.ResultPath.list  -output Fig