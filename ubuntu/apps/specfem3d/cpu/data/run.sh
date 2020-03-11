
cd /docker/run/ 

#mpirun  -np $numnodes $PWD/bin/xmeshfem3D
echo "mpirun -np 36 bin/xmeshfem3D"
mpirun --allow-run-as-root --report-bindings --map-by core --bind-to core --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm -np 36  /usr/local/specfem3d/bin/xmeshfem3D


echo "mpirun -np 36 bin/xspecfem3D"
mpirun --allow-run-as-root --report-bindings --map-by core --bind-to core --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm -np 36  /usr/local/specfem3d/bin/xspecfem3D



