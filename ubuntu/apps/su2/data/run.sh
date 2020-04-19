export OMP_NUM_THREADS=1
ulimit -s unlimited
cd /docker/run
mpirun --report-bindings --map-by socket --bind-to socket -np 64 SU2_CFD turb_ONERAM6.cfg
