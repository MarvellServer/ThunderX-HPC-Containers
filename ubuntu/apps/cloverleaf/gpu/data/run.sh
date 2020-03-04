if [ -z "$INPUT" ]; then
	INPUT=clover_bm256_short.in
fi

cd /docker/run
cp InputDecks/$INPUT clover.in
mpirun -np 2 --bind-to socket --map-by socket clover_leaf
