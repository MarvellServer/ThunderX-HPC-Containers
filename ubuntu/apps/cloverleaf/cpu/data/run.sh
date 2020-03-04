if [ -z "$INPUT" ]; then
	INPUT=clover_bm256_short.in
fi

cd /docker/run
cp InputDecks/$INPUT clover.in
mpirun -np 64 --bind-to core --map-by core clover_leaf
