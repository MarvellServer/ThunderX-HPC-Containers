
#!/bin/bash -x

# move to run directory
cd /docker/run/

# define environment
NTASKS_PER_SOCKET=32
export MCA_OPTS="--mca orte_base_help_aggregate 1"
export MPI_OPTS="--report-bindings --bind-to core --map-by ppr:$NTASKS_PER_SOCKET:socket"
export UCX_LOG_LEVEL=FATAL
ulimit -s unlimited

# define HACC Problem Size
GEOMETRY=4x4x4

# run
time mpirun -np 64 ${MPI_OPTS} ${MCA_OPTS} hacc_tpm indat cmbM000.tf m000 INIT ALL_TO_ALL -w -R -N 1 -t $GEOMETRY

bash
