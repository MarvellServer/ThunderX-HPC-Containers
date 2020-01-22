
#!/bin/bash

# move to run directory
cd /docker/run/

# define environment
export OMP_NUM_THREADS=1
export OMP_THREAD_LIMIT=64
export OMP_PLACES=cores
export OMP_PROC_BIND=close
export OMP_STACKSIZE=1G
export OMP_DISPLAY_ENV=TRUE

NTASKS_PER_SOCKET=32
export MCA_OPTS="--mca orte_base_help_aggregate 1 --mca btl_openib_allow_ib 1"
export MPI_OPTS="--allow-run-as-root --report-bindings --bind-to core --map-by ppr:$NTASKS_PER_SOCKET:socket"
export UCX_LOG_LEVEL=FATAL

ulimit -s unlimited

# define HACC Problem Size
GEOMETRY=4x4x4

# run
time mpirun ${MPI_OPTS} ${MCA_OPTS} hacc_tpm indat cmbM000.tf m000 INIT ALL_TO_ALL -w -R -N 1 -t $GEOMETRY

bash
