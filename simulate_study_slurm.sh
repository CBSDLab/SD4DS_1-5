#!/bin/bash
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -t 1:00:00
#SBATCH --output=my.stdout 
#SBATCH --mail-user=psh39@case.edu 
#SBATCH --mail-type=ALL 
#SBATCH --job-name="limits to growth.stmx study1"

#SBATCH -o serial-R.out%j # capture jobid in output file name

# load R module
module load R/4.4.2-gfbf-2024a

# run simulation study using AWK script
awk -f simulate_study.sh study1.csv