cd /docker/run
mpirun --report-bindings --map-by core --bind-to core -np 64 snap test.input output.txt
grep -rni Grind output.txt
