FROM    ubuntu:18.04

# Install basic packages
RUN     apt-get update -y && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            vim \
            sudo \
            git \
            wget \
            file \
            hwloc \
            tar \
            bc \
            openssh-client \
            bzip2 \
            pkg-config \
            ca-certificates \
            libnuma-dev \
            libevent-dev \
            autoconf \
            automake \
            binutils-dev \
            libhwloc-dev \
            libbinutils && \
        rm -rf /var/lib/apt/lists/*

# Add a user hpc_user and make sudoing require no passwor
RUN     groupadd -r hpc_user && \
        useradd -r -g hpc_user hpc_user && \
        usermod -aG sudo hpc_user && \
        sed -i '26d' /etc/sudoers && \
        sed -i '26i\%sudo   ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

# Setup git config
RUN     git config --global user.email "hpc_user" && git config --global user.name "hpc_user" && \
        mkdir -p /docker/src

COPY    VERSION /docker/src
COPY    Dockerfile /docker/src
RUN     cat /docker/src/VERSION | awk '{print "Dockerfile."$1}' | \
            xargs -I[] mv /docker/src/Dockerfile /docker/src/[] && \
        rm /docker/src/VERSION
