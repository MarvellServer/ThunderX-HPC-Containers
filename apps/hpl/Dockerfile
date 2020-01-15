FROM    marvell-hpc-gcc-libs:8.3.0_v4.0

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

# Copy Dockerfile
COPY    VERSION /docker/src
COPY    Dockerfile /docker/src
RUN     cat /docker/src/VERSION | awk '{print "Dockerfile."$1}' | \
            xargs -I[] mv /docker/src/Dockerfile /docker/src/[] && \
        rm /docker/src/VERSION

# Copy run scripts and datasets
COPY	data/HPL.dat /docker/run/
COPY	data/run.sh /docker/run
USER    hpc_user
ENTRYPOINT sh "/docker/run/run.sh"
