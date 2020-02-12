DEBFILE=BUILDDIR/data/cuda-repo-ubuntu1804-10-2-local-10.2.107-435.17.01_1.0-1_arm64.deb

if [ ! -f $DEBFILE ]; then
	echo "Required file $DEBFILE missing. Exiting !!"
	exit 1
fi

