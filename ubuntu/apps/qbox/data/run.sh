export OMP_NUM_THREADS=1
ulimit -s unlimited
export LANG=en_US.UTF-8
cd /docker/run
mpirun --report-bindings --map-by core --bind-to core --mca coll ^hcoll --mca pml ^ucx --mca btl self,vader -np 64 qb < ./gold.N320.i
