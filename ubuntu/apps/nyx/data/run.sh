export OMP_NUM_THREADS=1
ulimit -s unlimited

if [ ! -f "/docker/run/DATA/512ss_20mpc.nyx" ]; then
        echo "/docker/run/DATA/512ss_20mpc.nyx is missing !!!"
        exit 1
fi

cd /docker/run
mpirun -np 64 --bind-to socket --map-by socket --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm Nyx3d.gnu.MPI.OMP.ex inputs


