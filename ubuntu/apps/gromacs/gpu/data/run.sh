#!/bin/bash


cd /docker/run
tar -zxf ADH_bench_systems.tar.gz

cd adh_dodec

gmx_mpi grompp -f pme_verlet.mdp

export OMP_NUM_THREADS=31
MPI_PROCS=2
STEPS=5000
(mpirun --cpu-set 0-31 --bind-to socket --report-bindings -np $MPI_PROCS \
	gmx_mpi mdrun -v -pin off -nsteps $STEPS \
	-noconfout -g gromacs_output -npme 1 -ntomp_pme 1 -gpu_id 0 \
	-ntomp $OMP_NUM_THREADS -s topol.tpr -nb gpu -pme gpu 2>&1) > socket0.log &
mpirun --cpu-set 32-63 --bind-to socket --report-bindings -np $MPI_PROCS \
	gmx_mpi mdrun -v -pin off -nsteps $STEPS \
	-noconfout -g gromacs_output -npme 1 -ntomp_pme 1 -gpu_id 0 \
	-ntomp $OMP_NUM_THREADS -s topol.tpr -nb gpu -pme gpu 2>&1 | tee socket1.log
wait

export OMP_NUM_THREADS=16
MPI_PROCS=4
mpirun --map-by socket --bind-to socket --report-bindings -np $MPI_PROCS \
	gmx_mpi mdrun -v -pin off -nsteps $STEPS --gputasks 0011 \
	-noconfout -g gromacs_output  -npme 1 -ntomp_pme 1 \
	-ntomp $OMP_NUM_THREADS -s topol.tpr -nb gpu -pme gpu 2>&1 | tee dual_socket.log

echo "###################################################################"
echo "Performance of single GROMACS instance on both sockets"
grep "Performance:" -B 4 dual_socket.log

echo "###################################################################"
echo "Performance of single GROMACS instance on both sockets"
echo "Performance of Two separate GROMACS instances on each socket"
grep "Performance:" -B 4 socket*.log

echo "###################################################################"

