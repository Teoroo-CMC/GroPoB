#!/bin/bash -l

# Include your allocation number
#SBATCH -A 2021-1-32

# Name your job
#SBATCH -J 25mer0.08Tg 
#SBATCH -o Tg_540-140K.out

# Total number of nodes
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24
#SBATCH --constraint=group-2

# Test run for 1 hour
#SBATCH -t 24:00:00

#SBATCH --mail-type=ALL
#SBATCH --mail-user=hargu978

# here we use only one OpenMP thread per MPI task
export OMP_NUM_THREADS=1

# load the relevant modules
module swap PrgEnv-cray PrgEnv-gnu
module add gromacs/2021
#module add gromacs/2018.1

srun gmx_mpi mdrun -s npt.tpr -cpi npt.cpt -deffnm npt -v 

#srun gmx_mpi mdrun -cpi npt.cpt -deffnm npt -v
#cp npt.gro ../400K/npt_1000-400K.gro

rm \#*

