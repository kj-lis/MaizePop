#!/bin/bash
#SBATCH --job-name=XP_EHH
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G
#SBATCH --time=48:00:00
#SBATCH --account=g102-2488
#SBATCH --partition=okeanos
#SBATCH --output=/home/jl430796/MaizePop/logs/XP_EHH.%A_%a.out
#SBATCH --error=/home/jl430796/MaizePop/logs/XP_EHH.%A_%a.err
#SBATCH --array=1-10

set -euo pipefail

selscan \
--xpehh \
--hap pop1.hap \
--ref pop2.hap \
--pmap
--out chr1_pop1_vs_pop2 \
--threads 4