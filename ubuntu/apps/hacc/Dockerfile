
# HACC - Dockerfile

# define base image; all ARG read from cmd arguments --build-arg
ARG   base
FROM  ${base}

# define build version
ARG   version

# define build metadata
LABEL build_version=${version}
LABEL description="HACC Docker Image"

# author
MAINTAINER "Srikanth Yalavarthi"

# fetch source and extract
RUN   mkdir -p /tmp/hacc
COPY  data/HACC_1_7.tar.bz2 /tmp/hacc/HACC_1_7.tar.bz2
RUN   cd /tmp/hacc && \
      tar -xjvf HACC_1_7.tar.bz2 HACC_1_7/src

# clean and remove redundant files
RUN   cd /tmp/hacc/HACC_1_7/ && \
      bash -c 'source src/env/bashrc.vesta; cd src/; make clean;'
RUN   cd /tmp/hacc/HACC_1_7/ && \
      find -name '._*' | xargs rm -v && \
      find -name '*.a' | xargs rm -v && \
      find -name .svn -type d | xargs rm -rv

# define build config and compile
COPY  data/bashrc.tx2 /tmp/hacc/HACC_1_7/src/env
RUN   cd /tmp/hacc/HACC_1_7/src && \
      bash -c 'source env/bashrc.tx2 ; cd cpu; make clean; make'

# install
RUN   mkdir -p /usr/local/hacc/bin
RUN   bash -c 'source /tmp/hacc/HACC_1_7/src/env/bashrc.tx2; cp /tmp/hacc/HACC_1_7/src/cpu/${HACC_PLATFORM}/hacc_tpm /usr/local/hacc/bin'
ENV   PATH /usr/local/hacc/bin:${PATH}

# copy run script and input files
RUN   mkdir -p /docker/run
COPY  data/indat      /docker/run/
COPY data/cmbM000.tf  /docker/run/
COPY run.sh           /docker/run/

# copy dockerfile and build files to docker/src
RUN     mkdir -p /docker/src/
COPY    Dockerfile      /docker/src/
COPY    data            /docker/src/
COPY    docker_run.sh   /docker/src/
COPY    docker_build.sh /docker/src/
COPY    VERSION         /docker/src/
COPY    BASE            /docker/src/

# launch
USER        hpc_user
RUN         sudo chown -R hpc_user:hpc_user /docker/run/
ENTRYPOINT  bash "/docker/run/run.sh"
