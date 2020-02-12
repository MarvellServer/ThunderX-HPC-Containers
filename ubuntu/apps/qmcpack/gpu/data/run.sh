export OMP_NUM_THREADS=32

cd /docker/run

S=32
A=$((S * 4))
E=$((A * 12))

H5FILEDIR=/docker/run/NiO/h5files/
if [ ! -f "$H5FILEDIR/NiO-fcc-supertwist111-supershift000-S${S}.h5" ]; then
	echo "$PWD/h5files/NiO-fcc-supertwist111-supershift000-S${S}.h5 is missing !!!"
	echo "Download this file from https://anl.app.box.com/s/yxz1ic4kxtdtgpva5hcmlom9ixfl3v3c/folder/18160688946 into a host directory and map it into the container directory $H5FILEDIR
. Use the -v argument in docker run to make this mapping"
	echo "Eg: If /dir/containing/h5files is the path on host then give '-v /dir/containing/h5files:$H5FILEDIR' as the docker run argument"
	exit 1
fi

INPUT_XML=$PWD/NiO/dmc-a${A}-e${E}-cpu/NiO-fcc-S${S}-dmc.xml

sed -i "s#../NiO-fcc-super#NiO/h5files/NiO-fcc-super#g" $INPUT_XML
sed -i "s#../O.xml#NiO/O.xml#g" $INPUT_XML
sed -i "s#../Ni.opt.xml#NiO/Ni.opt.xml#g" $INPUT_XML

sed -i 's#<parameter name="walkers">                1 </parameter>#<parameter name="walkers">                __WALKERS__ </parameter>#g' $INPUT_XML


mpirun -np 2 --bind-to socket --map-by socket qmcpack $INPUT_XML
