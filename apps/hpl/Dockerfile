FROM    marvell-hpc-gcc-libs:8.3.0_v1.0

# Set environment variables
ENV	LD_LIBRARY_PATH=/usr/local/lib:/opt/arm/lib:${LD_LIBRARY_PATH} \
	PATH=/usr/local/hpl/bin/:${PATH} \
	CFLAGS="-O3 -fno-tree-vectorize -march=armv8.1-a+simd -mcpu=thunderx2t99 -finline-functions -ffast-math" \
	BLASLIB=libopenblas.a  \
	TOPDIR=/tmp/hpl/hpl-2.3

# Create necessary directories
RUN	mkdir -p /docker/run/ && \
	mkdir -p /docker/src/ && \
	mkdir -p /tmp/hpl

# Download source
RUN	cd /tmp/hpl && \
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

    #cp /tmp/hpl/hpl-2.3/THUNDERX2T99/bin/xhpl /usr/local/hpl/bin && \

RUN     groupadd -r hpc_user && useradd -r -g hpc_user hpc_user
USER    hpc_user

# Copy Dockerfile, run scripts and datasets
COPY	data/HPL.dat /docker/run/
COPY	Dockerfile /docker/src/ 
COPY	data/run.sh /
ENTRYPOINT sh "/run.sh"
