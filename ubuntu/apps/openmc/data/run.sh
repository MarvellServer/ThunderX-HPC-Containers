export OPENMC_CROSS_SECTIONS=/docker/run/DATA/endfb71_hdf5/cross_sections.xml


cd /docker/run


CROSS_SECTION_FILE_DIR=/docker/run/DATA/endfb71_hdf5
if [ ! -f "$CROSS_SECTION_FILE_DIR/cross_sections.xml" ]; then
        echo "$PWD/DATA/endfb71_hdf5/cross_sections.xml is missing !!!"
        echo "Download this file from https://anl.box.com/shared/static/9igk353zpy8fn9ttvtrqgzvw1vtejoz6.xz . Extract into a host directory and map it into the container directory $CROSS_SECTION_FILE_DIR. Use the -v argument in docker run to make this mapping."
        echo "Eg: If /dir/containing/cross_section_dir is the path on host then give '-v /dir/containing/cross_section_dir:$CROSS_SECTION_FILE_DIR' as the docker run argument"
        exit 1
fi


mpirun --allow-run-as-root --report-bindings --map-by core --bind-to core -np 64 openmc -s 4 /docker/run/DATA
