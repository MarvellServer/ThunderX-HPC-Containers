ARG     base
FROM    ${base}


ARG     version

#Setting the Environment variable
ENV	PATH=/usr/local/hpcg/bin:${PATH} \
	CFLAGS="-O3 -g -fprefetch-loop-arrays -mcpu=thunderx2t99 -march=armv8.1-a+lse -finline-functions -ffast-math  -fopenmp -funroll-loops -std=c++11 -ffp-contract=fast -L/usr/local/lib -larmpl_lp64 -lamath -I/usr/local/include"

#Creating the necessary directory
RUN	mkdir -p /docker/run/ && \
	mkdir -p /usr/local/hpcg/bin

#Getting the HPCG Source
RUN	mkdir -p /tmp/hpcg && \
	cd /tmp/hpcg && \
	git clone https://gitlab.com/arm-hpc/benchmarks/hpcg.git && \
	cd hpcg && git checkout -b tdg_bcol_merged remotes/origin/tdg_bcol_merged 
	
#Copy the input file
COPY	data/Make.THUNDERX2T99 /tmp/hpcg/hpcg/setup/ 
COPY	data/patches /tmp/hpcg/patches

#Building HPCG
RUN	cd /tmp/hpcg/hpcg && \
	git am ../patches/* && \
	sed -i "s#__OPT_FLAGS__#$CFLAGS#g" setup/Make.THUNDERX2T99 && \
	make arch=THUNDERX2T99 && \
	mv bin/xhpcg /usr/local/hpcg/bin/ && \
	mv bin/hpcg.dat /usr/local/hpcg/bin/ && \
	rm -rf /tmp/hpcg

COPY	data/run.sh /docker/run/

# Copy Dockerfile and associated build/run files into /docker/src
RUN     mkdir -p /docker/src/${version}
COPY    Dockerfile /docker/src/${version}
COPY    data /docker/src/${version}
COPY    docker_run.sh /docker/src/${version}
COPY    docker_build.sh /docker/src/${version}
COPY    VERSION /docker/src/${version}
COPY    BASE /docker/src/${version}

USER    hpc_user
ENTRYPOINT      sh "/docker/run/run.sh"
