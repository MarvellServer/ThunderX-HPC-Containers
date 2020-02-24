###############################################################################
# CMAKE                                                                       #
###############################################################################
FROM gcc9 AS cmake

RUN cd /tmp && \
    git clone https://gitlab.kitware.com/cmake/cmake.git && \
    cd cmake && \
    git fetch --all && \
    git checkout v3.16.3

RUN apt-get -y install libssl-dev
RUN cd /tmp/cmake && \
    mkdir build && \
    cd build && \
    CFLAGS="${CFLAGS} -idirafter /usr/include/aarch64-linux-gnu" CXXFLAGS="${CFLAGS} -idirafter /usr/include/aarch64-linux-gnu" ../configure --prefix=/usr/local --parallel=64 && \
    make -j64 && \
    make install
#
##ENV CFLAGS="${CFLAGS} -idirafter /usr/include/aarch64-linux-gnu"
#ENV CXXFLAGS="${CFLAGS} -idirafter /usr/include/aarch64-linux-gnu"
#RUN mkdir -p /tmp/cmake && \
#    wget -q -nc --no-check-certificate -P /tmp/cmake https://cmake.org/files/v3.14/cmake-3.14.5.tar.gz && \
#    mkdir -p /tmp/cmake && tar -x -f /tmp/cmake/cmake-3.14.5.tar.gz -C /tmp/cmake -z && \
#    cd /tmp/cmake/cmake-3.14.5 && ./bootstrap --prefix=/usr/local --parallel=$(nproc) && \
#    make -j$(nproc) && \
#    make install && \
#    rm -rf /tmp/cmake
