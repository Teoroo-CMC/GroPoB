#!/bin/bash
# time allocation
#SBATCH -A naiss2023-1-37
# name of this job
#SBATCH -o slurm2.out
#SBATCH -J tg
# wall time for this job
#SBATCH -t 02:00:00
# partition for this job
#SBATCH -p shared

# number of nodes
#SBATCH --nodes=1
# number of MPI processes per node
#SBATCH --ntasks-per-node=32
export OMP_NUM_THREADS=1

ml PDC
ml gromacs

rm \#* core

for conc in 0.02;do
srun gmx_mpi mdrun -s npt_${conc}.tpr -cpi npt_${conc}.cpt -deffnm npt_${conc} -v #-nsteps 130000
done

rm \#*

