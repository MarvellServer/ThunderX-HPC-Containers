export OMP_NUM_THREADS=1
ulimit -s unlimited
export OMP_PLACES=cores
export OMP_PROC_BIND=close
cd /docker/run

if [ "$RUN" == "waccm" ]; then
	export PATH=/usr/local/waccm/bin:${PATH}
	mpirun --report-bindings --map-by core --bind-to core -np 64 kernel.exe

elif [ "$RUN" == "mg2" ]; then
        export PATH=/usr/local/mg2/bin:${PATH}
        mpirun --report-bindings --map-by core --bind-to core -np 64 kernel.exe

elif [ "$RUN" == "clubb" ]; then
	export PATH=/usr/local/clubb/bin:${PATH}
	mpirun --report-bindings --map-by core --bind-to core -np 64 kernel.exe

else
	echo "Set input parameter'RUN' with one of following 'waccm/clubb/mg2' "
fi

