ulimit -s unlimited
cd /docker/run
#mpirun -x OMP_NUM_THREADS=1 --bind-to core --map-by core -np 64 pw.x -ndiag 4 < ausurf.in
mpirun -x OMP_NUM_THREADS=1 --bind-to core --map-by core -np 64 pw.x -ni 1 -nk 2 -nt 8 < ausurf.in #> out.mpi64.omp1.cnode11.bestpractflags
