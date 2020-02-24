cd /docker/run
mpirun --report-bindings --map-by core --bind-to core -np 64 amg -problem 1 -n 72 144 240 -P 4 4 4 -printstats
