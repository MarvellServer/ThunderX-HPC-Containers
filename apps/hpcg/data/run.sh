cd /docker/run/
export OMP_NUM_THREADS=1
MPI_PROCS=$((64/OMP_NUM_THREADS))
mpirun --allow-run-as-root --report-bindings --map-by socket:PE=$OMP_NUM_THREADS -np 64 xhpcg 64 128 128
grep -rni gflop *.txt
