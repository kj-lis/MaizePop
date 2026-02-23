#!/bin/sh
#SBATCH --job-name=zmays_plink_9
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/zmays_plink_9.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/zmays_plink_9.%A_%a.err