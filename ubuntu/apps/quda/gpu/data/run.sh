#!/bin/bash

cd /docker/run

export QUDA_RUN_DIR=/docker/run
export QUDA_INSTALL_DIR=/usr/local/quda

export QUDA_RESOURCE_PATH=${QUDA_RUN_DIR}
export QUDA_PROFILE_OUTPUT_BASE=profile
export QUDA_REORDER_LOCATION=GPU
# export QUDA_ENABLE_P2P=0/1/2/3
export QUDA_ENABLE_TUNING=1
export QUDA_ENABLE_DEVICE_MEMORY_POOL=1
export QUDA_ENABLE_PINNED_MEMORY_POOL=1
export QUDA_ENABLE_MANAGED_MEMORY=0
export QUDA_ENABLE_MANAGED_PREFETCH=0
export QUDA_ENABLE_NUMA=1
export QUDA_ENABLE_GDR=0
export CUDA_DEVICE_MAX_CONNECTIONS=1
export OMP_NUM_THREADS=2
export CUDA_VISIBLE_DEVICES=0,1

export MCA_OPTS="--mca orte_base_help_aggregate 1 --mca btl_openib_allow_ib 1"
export MPI_OPTS="--report-bindings --bind-to core --map-by ppr:1:socket"
export UCX_LOG_LEVEL=FATAL

# env
ulimit -s unlimited

# tune run
rm -f tunecache.tsv profile_0.tsv profile_async_0.tsv
time mpirun ${MCA_OPTS} ${MPI_OPTS} -np 1 ${QUDA_INSTALL_DIR}/bin/dslash_test --prec single --gridsize 1 1 1 1 --dim 32 32 32 64 --recon 12 --niter 10000

# actual run
sleep 3
time mpirun ${MCA_OPTS} ${MPI_OPTS} -np 1 ${QUDA_INSTALL_DIR}/bin/dslash_test --prec single --gridsize 1 1 1 1 --dim 32 32 32 64 --recon 12 --niter 10000
