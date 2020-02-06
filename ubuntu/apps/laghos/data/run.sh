
#!/bin/bash -x

# move to run directory
cd /docker/run/

# define environment
NTASKS_PER_SOCKET=32
export MCA_OPTS="--mca orte_base_help_aggregate 1"
export MPI_OPTS="--report-bindings --bind-to core --map-by ppr:$NTASKS_PER_SOCKET:socket"
export UCX_LOG_LEVEL=FATAL

# run
mpirun ${MCA_OPTS} ${MPI_OPTS} laghos -p 1 -m data/square_10x9_quad.mesh -rs 2 -rp 5 -pa -ok 3 -ot 2 -s 7 -o -q -ra -ms 4 -c '8 8'

bash
