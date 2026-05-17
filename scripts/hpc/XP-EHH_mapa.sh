#!/bin/bash
#SBATCH --job-name=XP_EHH_mapa
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH_mapa.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH_mapa.%A_%a.err
#SBATCH --array=1-10

