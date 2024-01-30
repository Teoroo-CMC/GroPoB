#!/bin/bash
# time allocation
#SBATCH -A naiss2023-1-37
# name of this job
#SBATCH -o slurm.out
#SBATCH -J sys_eq
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

#for conc in 0 0.02;do
#######NVT
#srun -n 1 gmx grompp -f nvt.mdp -c ../em/em_${conc}.gro -p ../topol_${conc}.top -o nvt_${conc}.tpr -maxwarn 2
#srun gmx_mpi mdrun -s nvt_${conc}.tpr -cpi nvt_${conc}.cpt -deffnm nvt_${conc} -v
#done

for conc in 0 0.02 ;do
#######NPT
#srun -n 1 gmx grompp -f npt.mdp -c nvt_${conc}.gro -p ../topol_${conc}.top -o npt_${conc}.tpr -maxwarn 2
srun gmx_mpi mdrun -s npt_${conc}.tpr -cpi npt_${conc}.cpt -deffnm npt_${conc} -nsteps 100000 -v
done

