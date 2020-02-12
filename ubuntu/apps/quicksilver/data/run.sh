cd /docker/run/
export OMP_NUM_THREADS=1

mpirun --report-bindings --map-by core --bind-to core --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm -np 64 ./bin/qs Examples/CTS2_Benchmark/CTS2.in  -X 64 -Y 64 -Z 64 -x 64 -y 64 -z 64 -I 4 -J 4 -K 4 -n 2621440 
