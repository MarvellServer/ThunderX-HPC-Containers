###############################################################################
# CMAKE                                                                       #
###############################################################################
FROM devel AS cmake
RUN mkdir -p /tmp/cmake && \
    wget -q -nc --no-check-certificate -P /tmp/cmake https://cmake.org/files/v3.14/cmake-3.14.5.tar.gz && \
    mkdir -p /tmp/cmake && tar -x -f /tmp/cmake/cmake-3.14.5.tar.gz -C /tmp/cmake -z && \
    cd /tmp/cmake/cmake-3.14.5 && ./bootstrap --prefix=/usr/local --parallel=$(nproc) && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/cmake

RUN	apt-get update -y && \
	DEBIAN_FRONTEND=noninteractive apt-get remove -y "*cuda*" "*dev-*" && \
	DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*
