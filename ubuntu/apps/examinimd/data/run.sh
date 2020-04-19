export OMP_NUM_THREADS=4
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
ulimit -s unlimited
cd /docker/run

SIZE=300
TIMESTEP=0.005
RUN=100
sed -i "s#__SIZE__#$SIZE#g" in.lj
sed -i "s#__TIMESTEP__#$TIMESTEP#g" in.lj
sed -i "s#__RUN__#$RUN#g" in.lj

mpirun -np 64 --bind-to core --map-by core --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm ExaMiniMD -il in.lj --comm-type MPI --kokkos-threads=$OMP_NUM_THREADS
