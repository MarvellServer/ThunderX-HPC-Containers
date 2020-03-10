###############################################################################
# CMAKE                                                                       #
###############################################################################
FROM devel AS cmake
RUN cd /tmp && \
    git clone https://gitlab.kitware.com/cmake/cmake.git && \
    cd cmake && \
    git fetch --all && \
    git checkout v3.16.3

RUN cd /tmp/cmake && \
    mkdir build && \
    cd build && \
    CFLAGS="${CFLAGS} -idirafter /usr/include/aarch64-linux-gnu" CXXFLAGS="${CFLAGS} -idirafter /usr/include/aarch64-linux-gnu" ../configure --prefix=/usr/local --parallel=64 && \
    make -j64 && \
    make install

RUN	apt-get update -y && \
	DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*
