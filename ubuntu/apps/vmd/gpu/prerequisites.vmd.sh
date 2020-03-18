if [ ! -d BUILDDIR/data/optix ]; then
	echo "
	Optix is expected to be installed in data/optix for the
	VMD build to succeed !
	"
	exit 1
fi

if [ ! -f BUILDDIR/data/vmd-1.9.4a39.src.tar.gz ]; then
	echo "
	Source Code Tar ball should be copied to data/vmd-1.9.4a39.src.tar.gz
	to build VMD !
	"
	exit 1
fi
