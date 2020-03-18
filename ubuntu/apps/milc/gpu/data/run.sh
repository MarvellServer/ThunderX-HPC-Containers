#!/bin/bash

echo $INPUT
export CUDA_VISIBLE_DEVICES=0,1
export OMP_NUM_THREADS=8
#export QUDA_ENABLE_P2P=1
#export QUDA_REORDER_LOCATION=GPU
export QUDA_RESOURCE_PATH=/docker/run/quda_resource

cd /docker/run
if [ "$INPUT" == "input.medium" ]; then
        wget --no-check-certificate https://portal.nersc.gov/project/m888/apex/MILC_lattices/36x36x36x72.chklat
	mpirun --allow-run-as-root -np 2 --mca pml ^ucx --bind-to socket --map-by socket su3_rhmd_hisq -qmp-geom 1 1 1 2 $INPUT
else
        wget --no-check-certificate https://portal.nersc.gov/project/m888/apex/MILC_lattices/18x18x18x36.chklat
	mpirun --allow-run-as-root -np 2 --mca pml ^ucx --bind-to socket --map-by socket su3_rhmd_hisq -qmp-geom 1 1 1 2 $INPUT
fi

