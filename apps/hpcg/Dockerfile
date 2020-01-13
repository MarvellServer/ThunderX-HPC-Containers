FROM marvell-hpc-gcc-libs:8.3.0_v2.0

#Setting the Environment variable
ENV	LD_LIBRARY_PATH=/usr/local/lib/:/opt/arm/lib:${LD_LIBRARY_PATH} \
	PATH=/usr/local/hpcg/bin:${PATH} \
	CFLAGS="-O3 -g -fprefetch-loop-arrays -mcpu=thunderx2t99 -march=armv8.1-a+lse -finline-functions -ffast-math  -fopenmp -funroll-loops -std=c++11 -ffp-contract=fast -L/usr/local/lib -larmpl_lp64 -lamath -I/usr/local/include"

#Creating the necessary directory
RUN	mkdir -p /docker/src/ && \
	mkdir -p /docker/run/ && \
	mkdir -p /usr/local/hpcg/bin

#Getting the HPCG Source
RUN	mkdir -p /tmp/hpcg && \
	cd /tmp/hpcg && \
	git clone https://gitlab.com/arm-hpc/benchmarks/hpcg.git && \
	cd hpcg && git checkout -b tdg_bcol_merged remotes/origin/tdg_bcol_merged 
	
#Copy the input file
COPY	data/Make.THUNDERX2T99 /tmp/hpcg/hpcg/setup/ 
ADD	data/patches /tmp/hpcg/patches

#Building HPCG
RUN	cd /tmp/hpcg/hpcg && \
	git am ../patches/* && \
	sed -i "s#__OPT_FLAGS__#$CFLAGS#g" setup/Make.THUNDERX2T99 && \
	make arch=THUNDERX2T99 && \
	mv bin/xhpcg /usr/local/hpcg/bin/ && \
	mv bin/hpcg.dat /usr/local/hpcg/bin/ && \
	rm -rf /tmp/hpcg

#RUN     groupadd -r hpc_user && useradd -r -g hpc_user hpc_user
#USER    hpc_user

COPY	Dockerfile /docker/src/
COPY	data/run.sh /

ENTRYPOINT      sh "/run.sh"
