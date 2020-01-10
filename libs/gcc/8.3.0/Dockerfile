FROM marvell-hpc-gcc:8.3.0
#UCX
# ./configure --prefix=/usr/local/ --disable-doxygen-doc --without-knem --with-cuda=/usr/local/cuda && \
RUN echo "----------------------------------------------------MARVELL_HPC_GCC_LIBS_VERSION_2.0v2020/01----------------------------------------------------------------------------" && \
    mkdir -p /tmp/ucx && \
    cd /tmp/ucx && \
    git clone https://github.com/openucx/ucx.git && \
    cd ucx && \
    git checkout v1.6.0 && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local --disable-doxygen-doc --without-knem && \
    make -j64 && make install -j64 && \
    rm -rf /tmp/ucx

# OPENMPI
RUN mkdir -p /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.0.tar.gz && \
    tar -zxf openmpi-4.0.0.tar.gz && \
    cd openmpi-4.0.0 && \
    ./configure --prefix=/usr/local --enable-mpi-cxx --with-cma --enable-mpirun-prefix-by-default --enable-mpi1-compatibility --with-ucx=/usr/local --disable-oshmem && \
    make -j && make install -j && \
    rm -rf /tmp/openmpi
#OPENBLAS-0.3.3
RUN mkdir -p /tmp/openblas && \
    cd /tmp/openblas && \
    wget https://github.com/xianyi/OpenBLAS/archive/v0.3.3.tar.gz && \
    tar -zxf v0.3.3.tar.gz && \
    cd OpenBLAS-0.3.3 && \
    make USE_THREAD=0 TARGET=THUNDERX2T99 CC=gcc -j64 && \
    make TARGET=THUNDERX2T99 CC=gcc PREFIX=/usr/local install && \
    rm -rf /tmp/openblas

#ARMPL-19.3
COPY data/include/* /usr/local/include/
COPY data/lib/* /usr/local/lib/

RUN  mkdir -p /docker/src

COPY data/appinfo.txt /docker/src/
COPY Dockerfile /docker/src/
