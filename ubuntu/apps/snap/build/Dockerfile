###############################################################################
# BASE                                                                        #
###############################################################################
FROM ubuntu:18.04 AS base
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	sudo && \
    rm -rf /var/lib/apt/lists/*

# Setup guest and give sudo permissions without password
RUN     groupadd -r guest && \
        useradd -r -g guest guest && \
        usermod -aG sudo guest && \
        sed -i '26d' /etc/sudoers && \
        sed -i '26i\%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

###############################################################################
# DEVEL                                                                       #
###############################################################################
FROM base as devel
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
        python \ 
	python-dev && \
    rm -rf /var/lib/apt/lists/*

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

# Setup environment paths
ENV     PATH=/usr/local/bin:${PATH} \
        LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH \
        LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LIBRARY_PATH \
	CC=gcc CXX=g++ FC=gfortran
###############################################################################
# UCX                                                                         #
###############################################################################
FROM devel AS ucx
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
FROM devel AS openmpi
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
# RUNTIME                                                                     #
###############################################################################
FROM base as runtime
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        openssh-client \
        libgfortran5 \
        libgomp1 \
	libnuma1 && \
    rm -rf /var/lib/apt/lists/*

# Setup environment paths
ENV     PATH=/usr/local/bin:${PATH} \
        LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH
###############################################################################
# SNAP                                                                        #
###############################################################################
FROM    devel AS snap

COPY  --from=ucx /usr/local /usr/local
COPY  --from=openmpi /usr/local /usr/local


#Creating the required directories
RUN   mkdir -p /tmp/snap && \
      mkdir -p /docker/src/ && \
      mkdir -p /docker/run && \
      mkdir -p /usr/local/snap/bin

ENV   PATH=/usr/local/snap/bin:${PATH}

# COPY Makefile and input file
COPY  data/Makefile /
COPY  data/utils.f90 /
COPY  data/test.input /docker/run/
COPY  data/run.sh /docker/run/

# Download and BUILD Source
RUN   cd /tmp/snap && \
      wget https://www.nersc.gov/assets/Trinity--NERSC-8-RFP/Benchmarks/June13/SNAPJune13.tar.gz && \
      tar -zxvf  SNAPJune13.tar.gz && rm -rf SNAPJune13.tar.gz && \
      cd SNAPJune13/src && \
      cp -r /Makefile . && \
      cp -r /utils.f90 . && \
      make snap && \
      cp -r snap /usr/local/snap/bin/

FROM    runtime
LABEL   MAINTAINER="Prince Takkar"
LABEL   MAINTAINER_EMAIL="ptakkar@marvell.com"
LABEL   SNAP_VERSION="SNAPJune13"

COPY    --from=openmpi /usr/local /usr/local
ENV     PATH=/usr/local/snap/bin/:${PATH}
COPY    --from=snap /usr/local/snap/bin /usr/local/snap/bin
COPY    --from=snap /docker/run /docker/run
COPY    ./ docker/src
USER    guest
RUN     sudo chown -R guest:guest /docker/run/
ENTRYPOINT  sh "/docker/run/run.sh"
LABEL BUILD_VERSION=2020.01-dev
LABEL DOCKERNAME=hpc/snap
LABEL BASE_VERSION=ubuntu-18.04
LABEL DEVEL_VERSION=gcc-8.3.0
LABEL UCX_VERSION=1.6.0
LABEL OPENMPI_VERSION=4.0.0
