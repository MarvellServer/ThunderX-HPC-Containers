#!/bin/bash
#PBS -S /bin/bash

## job name and output file
#PBS -N go_mesher_solver
#PBS -j oe
#PBS -o OUTPUT_FILES/job.o

###########################################################
# USER PARAMETERS

## 64 CPUs ( 8*8 ), walltime 5 hour
#PBS -l nodes=8:ppn=8,walltime=5:00:00

###########################################################

#cd $PBS_O_WORKDIR

echo "PWD"
pwd


#BASEMPIDIR=`grep ^LOCAL_PATH DATA/Par_file | cut -d = -f 2 `
BASEMPIDIR="./DATABASES_MPI"

# script to run the mesher and the solver
# read DATA/Par_file to get information about the run
# compute total number of nodes needed
NPROC_XI=`grep ^NPROC_XI DATA/Par_file | cut -d = -f 2 `
NPROC_ETA=`grep ^NPROC_ETA DATA/Par_file | cut -d = -f 2`
NCHUNKS=`grep ^NCHUNKS DATA/Par_file | cut -d = -f 2 `
# For 64 MPI ranks:
#NPROC_XI=8
#NPROC_ETA=8
#NCHUNKS=1
# For 40  MPI ranks:
#NPROC_XI=8
#NPROC_ETA=5
#NCHUNKS=1



# total number of nodes is the product of the values read
numnodes=$(( $NCHUNKS * $NPROC_XI * $NPROC_ETA ))

echo "numnodes"
echo $numnodes

mkdir -p OUTPUT_FILES

#EXWDIR="/workspace/pshukla/SPECFEM3D/v4-globe/specfem3d_globe/EXAMPLES/regional_MiddleEast"
#cd $EXWDIR

echo "PWD"
pwd



# backup files used for this simulation
cp DATA/Par_file OUTPUT_FILES/
cp DATA/STATIONS OUTPUT_FILES/
cp DATA/CMTSOLUTION OUTPUT_FILES/

echo "copied"
 
# obtain job information
#cat $PBS_NODEFILE > OUTPUT_FILES/compute_nodes
#echo "$PBS_JOBID" > OUTPUT_FILES/jobid

##
## mesh generation
##
sleep 2

echo
echo `date`
echo "starting MPI mesher on $numnodes processors"
echo

echo "numnodes:"
echo $numnodes
echo "PWD:"
pwd

#PWD="/workspace/pshukla/SPECFEM3D/v4-globe/specfem3d_globe"


#mpiexec -np $numnodes $PWD/bin/xmeshfem3D
mpirun --allow-run-as-root -np $numnodes $PWD/bin/xmeshfem3D

echo "  mesher done: `date`"
echo

# backup important files addressing.txt and list*.txt
cp OUTPUT_FILES/*.txt $BASEMPIDIR/


##
## forward simulation
##

# set up addressing
#cp $BASEMPIDIR/addr*.txt OUTPUT_FILES/
#cp $BASEMPIDIR/list*.txt OUTPUT_FILES/

sleep 2

echo
echo `date`
echo starting run in current directory $PWD
echo

echo "numnodes:"
echo $numnodes
echo "PWD:"
pwd 

#echo "numnodes: "
#echo $numnodes

#mpiexec -np $numnodes $PWD/bin/xspecfem3D
mpirun --allow-run-as-root -np $numnodes $PWD/bin/xspecfem3D

echo "mpirun $numnodes ..."
echo "xspecfem3D: finished successfully"
echo `date`

