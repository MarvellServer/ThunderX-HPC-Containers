#!/bin/bash

ulimit -s unlimited
#export OMP_NUM_THREADS=1
#export CUDA_VISIBLE_DEVICE=0
cd /docker/run
mpirun --map-by socket --bind-to socket -n 2 miniFE.x -nx 540 -ny 540 -nz 540
grep -r "Total CG Time" .
grep -r "Total CG Mflops" .
