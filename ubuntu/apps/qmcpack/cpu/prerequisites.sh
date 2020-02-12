APPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

H5FILE=$APPDIR/data/h5files/NiO-fcc-supertwist111-supershift000-S32.h5
if [ ! -f $H5FILE ]; then
	echo "Required file $H5FILE for building NiO performance tests missing."
	echo "Download from https://anl.box.com/s/yxz1ic4kxtdtgpva5hcmlom9ixfl3v3c. "
	echo "For more info, refer https://github.com/QMCPACK/qmcpack/blob/develop/tests/performance/NiO/README"
	echo "Exiting !!!"
	exit 1
fi


