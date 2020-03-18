export LD_LIBRARY_PATH=/docker/run/optix/lib64:$LD_LIBRARY_PATH

cd /docker/run
tar -zxvf festschrift.tar.gz

cd festschrift
vmd -e ChromCoverInstDOF.vmd
