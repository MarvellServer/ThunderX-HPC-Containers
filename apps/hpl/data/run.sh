export OMP_NUM_THREADS=1

cd /docker/run/ 
mpirun --report-bindings --map-by core --bind-to core --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm -np 64 xhpl
