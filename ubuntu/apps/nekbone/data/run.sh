#export OMP_NUM_THREADS=1
ulimit -s unlimited
cd /docker/run
mpirun --report-bindings --map-by core --bind-to core -np 64 nekbone
