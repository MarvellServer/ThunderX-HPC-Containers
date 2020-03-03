cd /docker/run

mpirun -np 64 --bind-to core --map-by socket -mca pml ucx -x UCX_TLS=sm python3.6 bmark.py
