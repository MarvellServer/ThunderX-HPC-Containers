ARG     base
FROM    ${base}

ARG     version
# Set environment variables
ENV	PATH=/usr/local/cp2k/bin/:${PATH}

ARG	CFLAGS="-O3 -mcpu=thunderx2t99 -march=armv8.1-a+lse -finline-functions -ffast-math -fprefetch-loop-arrays"
ARG     CC=mpicc
ARG     CXX=mpicxx
ARG     FC=mpif90

# Download source
RUN	mkdir -p /tmp/cp2k && \
        cd /tmp/cp2k && \
	git clone https://github.com/cp2k/cp2k.git && cd cp2k && git checkout v6.1.0
		
# Copy Makefile
COPY	data/Linux-Aarch64-gfortran.psmp /tmp/cp2k/cp2k/arch

# Build HPL
RUN	cd /tmp/cp2k/cp2k && \
        sed -i "s#__FFTW_DIR__#/usr/local/#g" arch/Linux-Aarch64-gfortran.psmp && \
        sed -i "s#__BLAS_DIR__#/usr/local/#g" arch/Linux-Aarch64-gfortran.psmp && \
        sed -i "s#__SCALAPACK_DIR__#/usr/local/#g" arch/Linux-Aarch64-gfortran.psmp && \
        sed -i "s#__FFTW_LIBS__#-lfftw3 -lfftw3_omp#g" arch/Linux-Aarch64-gfortran.psmp && \
        sed -i "s#__BLAS_LIBS__#-lopenblas#g" arch/Linux-Aarch64-gfortran.psmp && \
        sed -i "s#__SCALAPACK_LIBS__#-lscalapack#g" arch/Linux-Aarch64-gfortran.psmp && \
        sed -i "s#__FLAGS__#${CFLAGS}#g" arch/Linux-Aarch64-gfortran.psmp && \
        mkdir -p /usr/local/cp2k/bin && mkdir -p /docker/run && \
        cd makefiles && make ARCH=Linux-Aarch64-gfortran VERSION="psmp" -j && cd ../ && \
        cp exe/Linux-Aarch64-gfortran/cp2k.psmp /usr/local/cp2k/bin && \
        cp tests/QS/benchmark/H2O-256.inp /docker/run && \
        mkdir -p /docker/run/data && cp -r data/* /docker/run/data && \
        rm -rf /tmp/cp2k

COPY	data/run.sh /docker/run

# Copy Dockerfile and associated build/run files into /docker/src
RUN     mkdir -p /docker/src/${version}
COPY    Dockerfile /docker/src/${version}
COPY    data /docker/src/${version}
COPY    docker_run.sh /docker/src/${version}
COPY    docker_build.sh /docker/src/${version}
COPY    VERSION /docker/src/${version}
COPY    BASE /docker/src/${version}

USER    hpc_user
ENTRYPOINT sh "/docker/run/run.sh"
