cd /docker/run
INPUT=in.eam

mpirun -n 64 --bind-to core --map-by core --mca pml ^ucx -x UCX_TLS=sm lmp -k on -sf kk -pk kokkos neigh half neigh/qeq full newton on -var x 8 -var y 8 -var z 6 -in $INPUT 
#mpirun --allow-run-as-root --hostfile /hostfile -n 128 --bind-to core --map-by core /usr/local/bin/lmp -k on -sf kk -pk kokkos neigh half neigh/qeq full newton on -var x 8 -var y 8 -var z 6 -in $INPUT
