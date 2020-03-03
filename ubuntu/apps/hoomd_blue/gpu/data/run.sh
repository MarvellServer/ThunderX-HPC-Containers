cd /docker/run

mpirun -np 2 --bind-to socket --map-by socket python3.6 bmark.py
