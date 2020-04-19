export OMP_NUM_THREADS=4
ulimit -s unlimited

if [ ! -f "/docker/run/DATA/stokes.bin" ]; then
        echo "/docker/run/DATA/stokes.bin INPUTFILE is missing !!!"
        exit 1
fi

cd /docker/run
mpirun --bind-to socket --oversubscribe --map-by socket -np 64  -x HCOLL_RCACHE=^ucs miniVite -b -f DATA/stokes.bin
