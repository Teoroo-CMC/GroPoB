#!/bin/bash -l

# Include your allocation number
#SBATCH -A 2020-5-580
##SBATCH -A 2021-1-32

# Name your job
#SBATCH -J 250.08preeq
#SBATCH -o preeq_nvt_npt.out

# Total number of nodes
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=32
#SBATCH --constraint=group-2


# Test run for 1 hour
#SBATCH -t 04:00:00

#SBATCH --mail-type=ALL
#SBATCH --mail-user=hargu978

# here we use only one OpenMP thread per MPI task
export OMP_NUM_THREADS=1

# load the relevant modules
#module swap PrgEnv-cray PrgEnv-gnu
module add gromacs/2021


SYSDIR=/cfs/klemming/nobackup/h/hargu978/PEO_litfsi_nmer/MD
mdp=$SYSDIR/scripts_mdp/nvt_preeq.mdp
top=$SYSDIR/25mer/conc_0.08/topol.top

#srun gmx grompp -f $mdp -c ../em/em.gro -p $top -o nvt.tpr -maxwarn 2

#srun gmx_mpi mdrun -s nvt.tpr -cpi nvt.cpt -deffnm nvt -v

mdp=$SYSDIR/scripts_mdp/npt_preeq.mdp

#srun gmx grompp -f $mdp -c nvt.gro -p $top -o npt.tpr -maxwarn 2

srun gmx_mpi mdrun -s npt.tpr -cpi npt.cpt -deffnm npt -v

rm \#*

