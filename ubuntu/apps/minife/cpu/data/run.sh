#!/bin/bash
export OMP_NUM_THREADS=1

cd /docker/run
mpirun --report-bindings --map-by core --bind-to core -np 64 miniFE.x -nx 540 -ny 540 -nz 540
grep -r "Total CG Time" .
grep -r "Total CG Mflops" .
