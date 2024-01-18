#!/bin/bash -l

# Include your allocation number
#SBATCH -A 2021-1-32
##SBATCH -A 2020-5-580

# Name your job
#SBATCH -J 250.08400eq
#SBATCH -o 25eq400.out

# Total number of nodes
#SBATCH --nodes=8
##SBATCH --ntasks-per-node=32
##SBATCH --constraint=group-0

# Test run for 1 hour
#SBATCH -t 08:00:00

#SBATCH --mail-type=ALL
#SBATCH --mail-user=hargu978

# here we use only one OpenMP thread per MPI task
export OMP_NUM_THREADS=1

# load the relevant modules
#module swap PrgEnv-cray PrgEnv-gnu
module add gromacs/2021

SYSDIR=/cfs/klemming/nobackup/h/hargu978/PEO_litfsi_nmer/MD
mdp=$SYSDIR/scripts_mdp/npt_eq_T.mdp
top=$SYSDIR/25mer/conc_$c/topol.top

#srun gmx grompp -f $mdp -c ../preeq/npt.gro -p $top -o npt_eq.tpr -maxwarn 2

srun gmx_mpi mdrun -s npt_eq.tpr -cpi npt_eq.cpt -deffnm npt_eq -v

rm \#*
