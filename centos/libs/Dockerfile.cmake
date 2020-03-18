###############################################################################
# CMAKE                                                                       #
###############################################################################

FROM devel AS cmake

# install dependencies
RUN dnf -y install ncurses-devel \
      openssl-devel

# fetch source
RUN cd /tmp && \
    git clone https://gitlab.kitware.com/cmake/cmake.git && \
    cd cmake && \
    git fetch --all && \
    git checkout v3.16.3

# configure, build and install
RUN cd /tmp/cmake && \
    mkdir build && \
    cd build && \
    ../configure --prefix=/usr/local --parallel=64 && \
    make -j64 && \
    make -j64 install

# clean up
RUN rm -rf /tmp/cmake && \
    dnf -y autoremove && \
    dnf clean all
