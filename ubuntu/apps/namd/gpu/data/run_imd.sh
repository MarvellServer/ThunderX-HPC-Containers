cd /docker/run

if [ -z "$INPUT" ]; then
	INPUT=apoa1
fi

if [ ! -d $INPUT ]; then
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

	echo "IMDon    yes" >> ${INPUT}_nve_cuda.namd 
	echo "IMDport  2030" >> ${INPUT}_nve_cuda.namd 
	echo "IMDfreq  1" >> ${INPUT}_nve_cuda.namd 
	echo "IMDwait  on" >> ${INPUT}_nve_cuda.namd
        cd -	
fi
cd $INPUT

charmrun +p31 ++ppn31 namd2 +setcpuaffinity +pemap 0-30 +commap 31 +devices 0 ${INPUT}_nve_cuda.namd | tee result.out
python ./ns_per_day.py result.out

