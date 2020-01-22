###############################################################################
# BASE                                                                        #
###############################################################################
FROM ubuntu:18.04 AS base
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        g++-8 \
        gcc-8 \
	sudo \
        libnuma-dev \
        openssh-client \
        gfortran-8 && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc $(which gcc-8) 30 && \
    update-alternatives --install /usr/bin/g++ g++ $(which g++-8) 30 && \
    update-alternatives --install /usr/bin/gfortran gfortran $(which gfortran-8) 30 && \
    update-alternatives --install /usr/bin/gcov gcov $(which gcov-8) 30

# Setup hpc_user and give sudo permissions without password
RUN     groupadd -r hpc_user && \
        useradd -r -g hpc_user hpc_user && \
        usermod -aG sudo hpc_user && \
        sed -i '26d' /etc/sudoers && \
        sed -i '26i\%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

# Setup environment paths
ENV     PATH=/usr/local/bin:${PATH} \
        LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH \
        LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LIBRARY_PATH \
	CC=gcc CXX=g++ FC=gfortran

###############################################################################
# UTILS                                                                       #
###############################################################################
FROM base as utils
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	wget \
        git \
        automake \
        autoconf \
        libtool \
	m4 \
	pkg-config \
        ca-certificates \
        python && \
    rm -rf /var/lib/apt/lists/*
###############################################################################
# UCX                                                                         #
###############################################################################
FROM utils AS ucx
RUN mkdir -p /tmp/ucx && \
    cd /tmp/ucx && \
    git clone https://github.com/openucx/ucx.git && \
    cd ucx && \
    git checkout v1.6.0 && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --disable-doxygen-doc --without-knem && \
    make -j64 && make install -j64 && \
    rm -rf /tmp/ucx
###############################################################################
# OPENMPI                                                                     #
###############################################################################
FROM utils AS openmpi
COPY --from=ucx /usr/local /usr/local
RUN mkdir -p /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.gz && \
    tar -zxf openmpi-4.0.0.tar.gz && \
    cd openmpi-4.0.0 && \
    ./configure --prefix=/usr/local --enable-mpi-cxx --with-cma --enable-mpirun-prefix-by-default --enable-mpi1-compatibility --with-ucx=/usr/local --disable-oshmem && \
    make -j && make install -j && \
    rm -rf /tmp/openmpi
###############################################################################
# SPECFEM3D                                                                  #
# Maintainer: Parijat Shukla (email: pshukla@marvell.com)
###############################################################################
FROM    utils AS specfem3d

COPY    --from=openmpi	 /usr/local 	/usr/local

RUN 	apt-get update	&& \
 	ldconfig

# Create necessary directories
RUN     mkdir -p /docker/run/ && \
	mkdir -p /docker/run/DATA && \
	mkdir -p /docker/run/bin  && \
        mkdir -p /docker/src/ && \
        mkdir -p /tmp/specfem3d
                 

# Download source:
RUN	cd /tmp/specfem3d && \
        git clone  https://github.com/geodynamics/specfem3d_globe.git

# configure:
RUN	cd  /tmp/specfem3d/specfem3d_globe  && \
#        ./configure --enable-vectorization "FCFLAGS=  -std=gnu  -lstdc++ -lgfortran -O3" "CFLAGS=-O3"
        ./configure --enable-vectorization "FCFLAGS=  -std=gnu  -lstdc++ -lgfortran -O3" "CFLAGS=-O3 -fno-tree-vectorize -march=armv8.1-a+simd -mcpu=thunderx2t99 -finline-functions -ffast-math"
# copy Makefile:
COPY	data/Makefile.gold /tmp/specfem3d/specfem3d_globe/Makefile && \
	data/go_mesher_solver_pbs.bash /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/. 	&& \
 	data/run_this_example.sh       /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/.	&& \
 	data/Par_file.8x8              /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/DATA/Par_file 

# Build SPECFEM3D:
RUN	cd /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast && \ 
	mkdir -p DATABASES_MPI && mkdir -p OUTPUT_FILES && \ 
    	rm -rf DATABASES_MPI/* && rm -rf OUTPUT_FILES/* && \
    	cd ../../ 					&& \
    	cp EXAMPLES/regional_MiddleEast/DATA/Par_file DATA/Par_file && \
	make clean && \
	make xmeshfem3D && \
	make xspecfem3D

# Copy Dockerfile, run scripts and datasets
COPY    data/go_mesher_solver_pbs.bash  /docker/run/ 	&& \
	data/run_this_example.sh 	/docker/run/
# copy other auxillary files:
RUN 	cp -r /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/DATA/CMTSOLUTION /docker/run/DATA/.	&& \
	cp    /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/DATA/Par_file /docker/run/DATA/.	&& \
 	cp -r /tmp/specfem3d/specfem3d_globe/DATA/crust2.0    /docker/run/DATA/.	&& \
 	cp -r /tmp/specfem3d/specfem3d_globe/DATA/QRFSI12     /docker/run/DATA/.	&& \
 	cp /tmp/specfem3d/specfem3d_globe/DATA/STATIONS       /docker/run/DATA/.	&& \
 	cp -r /tmp/specfem3d/specfem3d_globe/DATA/s362ani     /docker/run/DATA/.	&& \
 	cp -r /tmp/specfem3d/specfem3d_globe/DATA/topo_bathy  /docker/run/DATA/.	&& \
 	cp /tmp/specfem3d/specfem3d_globe/bin/xmeshfem3D	/docker/run/bin/.	&& \
 	cp /tmp/specfem3d/specfem3d_globe/bin/xspecfem3D	/docker/run/bin/.

COPY    Dockerfile  	/docker/src/	&& \
	data/run.sh 	/docker/run/	

RUN 	mkdir -p /docker/run/DATABASES_MPI	&& \
	mkdir -p /docker/run/OUTPUT_FILES	&& \
	cp /docker/run/DATA/Par_file 	/docker/run/OUTPUT_FILES/	&& \
	cp /docker/run/DATA/STATIONS  	/docker/run/OUTPUT_FILES/	&& \
	cp /docker/run/DATA/CMTSOLUTION /docker/run/OUTPUT_FILES/	


FROM    base
COPY    --from=openmpi /usr/local 		/usr/local
ENV     PATH=/docker/run/bin/:${PATH}
COPY    --from=specfem3d /docker/run 		/docker/run
COPY    ./ 	docker/src
RUN     chown -R hpc_user:hpc_user /docker
USER    hpc_user

# commenting out its working only with root privs:
#RUN     groupadd -r hpc_user && useradd -r -g hpc_user hpc_user
#USER    hpc_user

#ENTRYPOINT sh "/run.sh"
ENTRYPOINT sh "/docker/run/run.sh"
 
