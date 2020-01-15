FROM marvell-hpc-base:v1.0
# GNU compiler

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        g++-8 \
        gcc-8 \
        gfortran-8 \
        make \
        libtool \
	flex \
        libgfortran3 \
        libgomp1 \
	libnl-3-200 \
        libnl-route-3-200 \
        libpmi2-0 && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc $(which gcc-8) 30 && \
    update-alternatives --install /usr/bin/g++ g++ $(which g++-8) 30 && \
    update-alternatives --install /usr/bin/gfortran gfortran $(which gfortran-8) 30 && \
    update-alternatives --install /usr/bin/gcov gcov $(which gcov-8) 30

ENV	LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH} \
        PATH=/usr/local/bin:$PATH

COPY    VERSION /docker/src
COPY    Dockerfile /docker/src
RUN     cat /docker/src/VERSION | awk '{print "Dockerfile."$1}' | \
            xargs -I[] mv /docker/src/Dockerfile /docker/src/[] && \
        rm /docker/src/VERSION
