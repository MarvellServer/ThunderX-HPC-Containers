export OMP_NUM_THREADS=4
ulimit -s unlimited
cd /docker/run
TOTALX=12
TOTALY=16
TOTALZ=20

NX=2
NY=4
NZ=4

ZX=$((TOTALX/NX))
ZY=$((TOTALY/NY))
ZZ=$((TOTALZ/NZ))

sed -i "s#NX1#$((NX-1))#g" grid.cmg
sed -i "s#NY1#$((NY-1))#g" grid.cmg
sed -i "s#NZ1#$((NZ-1))#g" grid.cmg

sed -i "s#NX#$NX#g" grid.cmg
sed -i "s#NY#$NY#g" grid.cmg
sed -i "s#NZ#$NZ#g" grid.cmg

sed -i "s#ZX#$ZX#g" grid.cmg
sed -i "s#ZY#$ZY#g" grid.cmg
sed -i "s#ZZ#$ZZ#g" grid.cmg

ORDER=16
NUMGROUPS=200
QUADTYPE=2
POLAR=9
AZIM=10
mpirun -np 32 --report-bindings --bind-to core --map-by socket:PE=2 --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm SuOlsonTest grid.cmg $NUMGROUPS $QUADTYPE $ORDER $POLAR $AZIM
