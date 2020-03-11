
# update Parfile:
#cd DATA
#cp Par_file_128x128_100_2GPU    Par_file
#cd ..
# change to run dir:
cd /docker/run
echo "pwd:" 
pwd
ls

# clean and build: 
#make clean
#make -j64

# using 1 GPUs: note that xmeshfem3D is run on CPU only
#mpirun -np 1 /usr/local/specfem3d/bin/xmeshfem3D
#mpirun -np 1  /usr/local/specfem3d/bin/xspecfem3D 


# using 2 GPUs:
mpirun -np 2 /usr/local/specfem3d/bin/xmeshfem3D
mpirun -np 2  /usr/local/specfem3d/bin/xspecfem3D



