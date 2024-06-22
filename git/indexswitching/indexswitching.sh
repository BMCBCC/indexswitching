#!/bin/bash
#SBATCH -N 1                      # Number of nodes. You must always set -N 1 unless you receive special instruction from the system admin
#SBATCH -n 4                      # Number of CPUs. Equivalent to the -pe whole_nodes 1 option in SGE

module add miniconda3/v4
source /home/software/conda/miniconda3/bin/condainit
conda activate nextflow
module add singularity/3.5.0

nextflow run indexswitching.nf --fastq $1 --knownbarcodes $2 --outdir $3 -resume
