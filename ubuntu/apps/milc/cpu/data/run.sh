#!/bin/bash

echo $INPUT
export OMP_NUM_THREADS=2

cd /docker/run
if [ "$INPUT" == "input.medium" ]; then
	wget --no-check-certificate https://portal.nersc.gov/project/m888/apex/MILC_lattices/36x36x36x72.chklat
	mpirun --report-bindings --map-by socket --bind-to socket --mca coll ^hcoll --mca pml ^ucx --mca btl self,vader -np 32 su3_rhmd_hisq -qmp-geom 2 2 2 4 $INPUT
else
	wget --no-check-certificate https://portal.nersc.gov/project/m888/apex/MILC_lattices/18x18x18x36.chklat
	mpirun --report-bindings --map-by socket --bind-to socket --mca coll ^hcoll --mca pml ^ucx --mca btl self,vader -np 32 su3_rhmd_hisq -qmp-geom 2 2 2 4 $INPUT
fi


