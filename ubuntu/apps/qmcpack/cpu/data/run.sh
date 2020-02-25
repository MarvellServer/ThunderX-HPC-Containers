export OMP_NUM_THREADS=32

cd /docker/run

S=32
A=$((S * 4))
E=$((A * 12))

H5FILEDIR=/docker/run/S32_example
if [ ! -f "$H5FILEDIR/NiO-fcc-supertwist111-supershift000-S${S}.h5" ]; then
	echo "$H5FILEDIR/NiO-fcc-supertwist111-supershift000-S${S}.h5 is missing !!!"
	exit 1
fi

cd /docker/run

INPUT_XML=/docker/run/NiO-fcc-S${S}-dmc.xml

sed -i "s#/host_pwd/#$PWD#g" $INPUT_XML

mpirun -np 2 --bind-to socket --map-by socket qmcpack $INPUT_XML
