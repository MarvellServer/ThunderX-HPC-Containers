cd /docker/run

if [ -z "$INPUT" ]; then
	INPUT=apoa1
fi
if [ "$INPUT" ==  "apoa1" ]; then
	wget http://www.ks.uiuc.edu/Research/namd/utilities/apoa1.tar.gz
	tar zxvf apoa1.tar.gz
	cd apoa1
	wget http://www.ks.uiuc.edu/Research/namd/2.13/benchmarks/apoa1_nve_cuda.namd
	sed -i "s/outputEnergies/#outputEnergies/g" apoa1_nve_cuda.namd
	echo "outputEnergies 5000" >> apoa1_nve_cuda.namd 
	wget http://www.ks.uiuc.edu/Research/namd/2.13/benchmarks/ns_per_day.py
fi
if [ "$INPUT" == "stmv" ]; then
	wget http://www.ks.uiuc.edu/Research/namd/utilities/stmv.tar.gz
	tar zxvf stmv.tar.gz
	cd stmv
	wget http://www.ks.uiuc.edu/Research/namd/2.13/benchmarks/stmv_nve_cuda.namd
	wget http://www.ks.uiuc.edu/Research/namd/2.13/benchmarks/ns_per_day.py
fi

charmrun +p62 ++ppn62 namd2 +setcpuaffinity +pemap 0-30,32-62 +commap 31,63 ${INPUT}_nve_cuda.namd | tee result.out
python ./ns_per_day.py result.out

