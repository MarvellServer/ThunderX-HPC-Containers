export OMP_NUM_THREADS=4
ulimit -s unlimited
mkdir -p /docker/run/rsl
cd /docker/run/bench_run
cp -r /docker/run/RRTM_DATA /docker/run/bench_run/

mpirun --report-bindings --map-by socket --bind-to socket -np 32 --mca coll ^hcoll -x UCX_TLS=sm --mca btl ^openib wrf.exe
socmon -D > /dev/null 2>&1 &
mv wrfout_d01_2001-10-24_12:00:00 /docker/run/rsl/
mv rsl* /docker/run/rsl/
cd /docker/run/
/bin/bash parse_single.sh
cat result_gflops.txt
