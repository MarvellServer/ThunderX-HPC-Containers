export OMP_NUM_THREADS=2
ulimit -s unlimited
cd /docker/run
mpirun --report-bindings --map-by socket --bind-to socket -np 64 sw4lite LOH.1-h50.in
