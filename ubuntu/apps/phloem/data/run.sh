export OMP_NUM_THREADS=1
ulimit -s unlimited
cd /docker/run

if [ "$INPUT" == "Bandwidth" ]; then
	mpirun -np 64 --report-bindings --bind-to socket --map-by socket  --mca coll ^hcoll --mca btl self,vader --mca pml ^ucx com -m bw.message.sizes -w BidirAsync
else
	mpirun -np 64 --report-bindings --bind-to socket --map-by socket --mca coll ^hcoll --mca btl ^openib,self,vader --mca pml ucx -x UCX_TLS=sm,self com -m latency.message.sizes -w Latency
fi

