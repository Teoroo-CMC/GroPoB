#!/usr/bin/bash
module load lammps/11Aug17
mpirun -np 48 lmp < in.lammps > log.lammps
