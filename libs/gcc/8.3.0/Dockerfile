FROM 16.16.16.249:5000/marvell-hpc-gcc:8.3.0

#UCX-1.6.0
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

#OPENMPI-4.0.0
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

#Binutils-2.33.1
RUN mkdir -p /tmp/binutils && \
    cd /tmp/binutils && \
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz && \
    tar -zxvf binutils-2.33.1.tar.gz && \
    cd binutils-2.33.1 && \
    ./configure --prefix=/usr/local && make -j && \
    make install && \
    rm -rf /tmp/binutils


#CMAKE-3.14.5
RUN mkdir -p /tmp/cmake && \
    wget -q -nc --no-check-certificate -P /tmp/cmake https://cmake.org/files/v3.14/cmake-3.14.5.tar.gz && \
    mkdir -p /tmp/cmake && tar -x -f /tmp/cmake/cmake-3.14.5.tar.gz -C /tmp/cmake -z && \
    cd /tmp/cmake/cmake-3.14.5 && ./bootstrap --prefix=/usr/local --parallel=$(nproc) && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/cmake

ENV LD_LIBRARY_PATH=/usr/local/lib
#FFTW-3.3.8
RUN mkdir -p /tmp/fftw3 && \
    cd /tmp/fftw3 && \
    wget http://www.fftw.org/fftw-3.3.8.tar.gz && \
    tar -zxf fftw-3.3.8.tar.gz && \
    mkdir build && cd build && \
    ../fftw-3.3.8/configure --prefix=/usr/local --enable-neon --enable-fma --enable-generic-simd128 --enable-armv8-cntvct-el0 --enable-mpi --enable-openmp --enable-threads --enable-shared --enable-static --enable-fortran && make -j && make install && cd .. && \
    mkdir buildf && cd buildf && \
    ../fftw-3.3.8/configure --prefix=/usr/local --enable-neon --enable-fma --enable-generic-simd128 --enable-armv8-cntvct-el0 --enable-mpi --enable-openmp --enable-threads --enable-shared --enable-static --enable-fortran --enable-single && make -j && make install && cd .. && \
     rm -rf /tmp/fftw3



#SCALAPACK-2.0.2
RUN mkdir -p /tmp/scalapack && \
    cd /tmp/scalapack && \
    wget https://github.com/Reference-ScaLAPACK/scalapack/archive/v2.1.0.tar.gz && \
    tar -zxvf v2.1.0.tar.gz && \
    cd scalapack-2.1.0 && \
    cmake \
        -DMPI_Fortran_COMPILER=mpif90 \
        -DMPI_C_COMPILER=mpicc \
        -DCMAKE_C_COMPILER=gcc \
        -DCMAKE_Fortran_COMPILER=gfortran \
        -DCMAKE_Fortran_FLAGS="-O3 -mcpu=thunderx2t99 -march=armv8.1-a+lse -finline-functions -fPIC" \
        -DCMAKE_C_FLAGS="-O3 -mcpu=thunderx2t99 -march=armv8.1-a+lse -finline-functions -fPIC" \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DBUILD_SHARED_LIBS=ON \
        . && \
    make -j64 && make install && \
    rm -rf /tmp/scalapack

#ARMPL-19.3
COPY data/include/* /usr/local/include/
COPY data/lib/* /usr/local/lib/

RUN  mkdir -p /docker/src

COPY data/appinfo.txt /docker/src/
COPY Dockerfile /docker/src/
