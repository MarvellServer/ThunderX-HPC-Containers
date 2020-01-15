ARG     base
FROM    ${base}

ARG     version
# Set environment variables
ENV	PATH=/usr/local/hpl/bin/:${PATH} \
	CFLAGS="-O3 -fno-tree-vectorize -march=armv8.1-a+simd -mcpu=thunderx2t99 -finline-functions -ffast-math" \
	BLASLIB=libopenblas.a  \
	TOPDIR=/tmp/hpl/hpl-2.3

# Download source
RUN	mkdir -p /tmp/hpl && \
        cd /tmp/hpl && \
	wget http://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz && tar -zxvf hpl-2.3.tar.gz
		
# Copy Makefile
COPY	data/Make.THUNDERX2T99.gcc /tmp/hpl/hpl-2.3/Make.THUNDERX2T99

# Build HPL
RUN	cd /tmp/hpl/hpl-2.3 && \
	sed -i "s#__OPT_FLAGS__#$CFLAGS#g" Make.THUNDERX2T99 && \
	sed -i "s#__TOPDIR__#$TOPDIR#g" Make.THUNDERX2T99 && \
	sed -i "s#__BLAS_LIB__#$BLASLIB#g" Make.THUNDERX2T99 &&  \
        mkdir -p /usr/local/hpl/bin && \
	make arch=THUNDERX2T99 && \
        rm -rf /tmp/hpl/

# Copy run scripts and datasets
COPY	data/HPL.dat /docker/run/
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
