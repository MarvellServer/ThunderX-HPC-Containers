# based on run_this_example.sh and go_mesher_solver_pbs.bash
# consider 'run' dir in docker as same as testcase dir in original SPECFEM3D distributions.

export OMP_NUM_THREADS=1

cd /docker/run/ 

# from run_this_example.sh:
#mkdir -p DATABASES_MPI
#mkdir -p OUTPUT_FILES
#rm -rf DATABASES_MPI/*
#rm -rf OUTPUT_FILES/*
#BASEMPIDIR="./DATABASES_MPI"
#NPROC_XI=`grep ^NPROC_XI DATA/Par_file | cut -d = -f 2 `
#NPROC_ETA=`grep ^NPROC_ETA DATA/Par_file | cut -d = -f 2`
#NCHUNKS=`grep ^NCHUNKS DATA/Par_file | cut -d = -f 2 `
#numnodes=$(( $NCHUNKS * $NPROC_XI * $NPROC_ETA ))
#numnodes=36
numnodes=64
echo "numnodes"
echo $numnodes
# already there:
#EXWDIR="/workspace/pshukla/SPECFEM3D/v4-globe/specfem3d_globe/EXAMPLES/regional_MiddleEast"
#cd $EXWDIR
# moved to Dockerfile:
#mkdir -p DATABASES_MPI
#mkdir -p OUTPUT_FILES
#pwd
#ls
#cp DATA/Par_file OUTPUT_FILES/
#cp DATA/STATIONS OUTPUT_FILES/
#cp DATA/CMTSOLUTION OUTPUT_FILES/
echo "copied"
sleep 2
echo
echo `date`
echo "starting MPI mesher on $numnodes processors"
echo
echo "numnodes:"
echo $numnodes
echo "PWD:"
pwd
#mpirun  -np $numnodes $PWD/bin/xmeshfem3D
echo "  mesher started: `date`"
mpirun --allow-run-as-root --report-bindings --map-by core --bind-to core --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm -np $numnodes  bin/xmeshfem3D
echo "  mesher done: `date`"
echo
#cp OUTPUT_FILES/*.txt $BASEMPIDIR/
mpirun  -np $numnodes $PWD/bin/xspecfem3D
echo "  specfem3D solver started: `date`"
mpirun --allow-run-as-root --report-bindings --map-by core --bind-to core --mca coll ^hcoll --mca btl ^openib --mca pml ucx -x UCX_TLS=self,sm -np $numnodes  bin/xspecfem3D
echo "mpirun $numnodes ..."
echo "  specfem3D solver finished successfully: `date`"


