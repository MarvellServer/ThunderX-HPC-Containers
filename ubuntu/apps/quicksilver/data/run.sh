
#cd src
#echo "PWD"
#pwd

echo "in docker: run.sh"

export OMP_NUM_THREADS=1

cd /docker/run/

# 4.538 X pow(10,7):
mpirun --report-bindings --map-by core --bind-to core --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm -np 64 ./bin/qs Examples/CTS2_Benchmark/CTS2.in  -X 64 -Y 64 -Z 64 -x 64 -y 64 -z 64 -I 4 -J 4 -K 4 -n 2621440 > out.log.mpi64

~

ls 
tail out.log.mpi64


# baremetal performance: 4.9 X pow(10,7):
#mpirun --report-bindings --bind-to core --map-by core -np 64 ././qs ../Examples/CTS2_Benchmark/CTS2.in -X 64 -Y 64 -Z 64 -x 64 -y 64 -z 64 -I 4 -J 4 -K 4 -n 2621440 > out.log.mpi64

#mpirun --report-bindings --bind-to core --map-by core -np 32 ././qs ../Examples/CTS2_Benchmark/CTS2.in -X 32 -Y 64 -Z 64 -x 32 -y 64 -z 64 -I 2 -J 4 -K 4 -n 2621440 > out.log.mpi32

#mpirun --report-bindings --bind-to core --map-by core -np 16 ././qs ../Examples/CTS2_Benchmark/CTS2.in -X 32 -Y 64 -Z 32 -x 32 -y 64 -z 32 -I 2 -J 4 -K 2 -n 2621440 > out.log.mpi16

#mpirun --report-bindings --bind-to core --map-by core -np 8 ././qs ../Examples/CTS2_Benchmark/CTS2.in -X 32 -Y 32 -Z 32 -x 32 -y 32 -z 32 -I 2 -J 2 -K 2 -n 2621440 > out.log.mpi8


