export OMP_NUM_THREADS=1
ulimit -s unlimited
cd /docker/run
mpirun --report-bindings --map-by core --bind-to core -np 64 ma.x --num_refine 4 --max_blocks 6000 --init_x 1 --init_y 1 --init_z 1 --npx 4 --npy 4 --npz 4 --nx 8 --ny 8 --nz 8 --num_objects 1 --object 2 0 -0.01 -0.01 -0.01 0.0 0.0 0.0 0.0 0.0 0.0 0.0009 0.0009 0.0009 --num_tsteps 800 --comm_vars 2 | tee out.log
TIME=`cat out.log | grep -wi "Summary" | sed -e "s/ /,/g" | cut -d "," -f9`
TIMESTEP=`cat out.log | grep -wi "Summary" | sed -e "s/ /,/g" | cut -d "," -f7`
BLOCKS=`cat out.log | grep -wi "Summary" | sed -e "s/ /,/g" | cut -d "," -f21`
FOM=`printf "%.7f" $(bc -l <<< "${TIME}/${TIMESTEP}/${BLOCKS}")`
echo "#########Final FOM (Time/Blocks) is $FOM###########"
