#!/bin/bash


cd /docker/run
tar -zxf ADH_bench_systems.tar.gz

cd adh_dodec

gmx_mpi grompp -f pme_verlet.mdp

export OMP_NUM_THREADS=1
mpirun -np 64 --mca pml ^ucx --bind-to socket --map-by socket gmx_mpi mdrun -v -pin on -nsteps 5000 -noconfout -g gromacs_output -npme 0 -ntomp $OMP_NUM_THREADS -s topol.tpr



