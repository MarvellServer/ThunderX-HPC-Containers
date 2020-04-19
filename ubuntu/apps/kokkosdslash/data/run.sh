export OMP_NUM_THREADS=128
export OMP_PROC_BIND=spread

export OMP_PLACES=threads
ulimit -s unlimited
cd /docker/run
mpirun -np  1 --bind-to none test_kokkos_vperf
