#!/bin/sh
#SBATCH --job-name=xp_ehh
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/xp_ehh.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/xp_ehh.%A_%a.err
#SBATCH --array=1-10