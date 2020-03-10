if [ ! -d BUILDDIR/data/optix ]; then
	echo "
	Optix is expected to be installed in data/optix for the
	VMD build to succeed !
	"
	exit 1
fi
