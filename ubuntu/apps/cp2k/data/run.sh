export OMP_NUM_THREADS=1
export CP2K_DATA_DIR=/docker/run/data

cd /docker/run
mpirun --report-bindings --bind-to socket --map-by core -np 64 cp2k.psmp -i H2O-256.inp
