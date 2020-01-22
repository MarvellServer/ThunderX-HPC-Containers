# copied from the raw version:
FROM 	16.16.16.249:5000/marvell-hpc-gcc-libs:8.3.0_v1.0

RUN 	apt-get update
RUN 	ldconfig

# Create necessary directories
RUN     mkdir -p /docker/run/ && \
	mkdir -p /docker/run/DATA && \
	mkdir -p /docker/run/bin  && \
        mkdir -p /docker/src/ && \
        mkdir -p /tmp/specfem3d
                 

# Download source:
RUN	cd /tmp/specfem3d && \
        git clone  https://github.com/geodynamics/specfem3d_globe.git && ls

# configure:
RUN	cd  /tmp/specfem3d/specfem3d_globe  && \
        ./configure --enable-vectorization "FCFLAGS=  -std=gnu  -lstdc++ -lgfortran -O3" "CFLAGS=-O3"
# copy Makefile:
COPY	data/Makefile.gold /tmp/specfem3d/specfem3d_globe/Makefile
COPY	data/go_mesher_solver_pbs.bash /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/.
COPY 	data/run_this_example.sh       /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/.
#COPY 	data/Par_file.6x6              /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/DATA/Par_file
COPY 	data/Par_file.8x8              /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/DATA/Par_file

# Build SPECFEM3D:
RUN	cd /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast && \ 
	mkdir -p DATABASES_MPI && mkdir -p OUTPUT_FILES && \ 
    	rm -rf DATABASES_MPI/* && rm -rf OUTPUT_FILES/* && \
    	cd ../../ && pwd && \
    	cp EXAMPLES/regional_MiddleEast/DATA/Par_file DATA/Par_file && \
	make clean && \
	make xmeshfem3D && \
	make xspecfem3D

# Copy Dockerfile, run scripts and datasets
COPY    data/go_mesher_solver_pbs.bash  /docker/run/
COPY    data/run_this_example.sh 	/docker/run/
# copy other auxillary files:
RUN 	cp -r /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/DATA/CMTSOLUTION /docker/run/DATA/.
RUN     cp    /tmp/specfem3d/specfem3d_globe/EXAMPLES/regional_MiddleEast/DATA/Par_file /docker/run/DATA/.
RUN 	cp -r /tmp/specfem3d/specfem3d_globe/DATA/crust2.0    /docker/run/DATA/.
RUN 	cp -r /tmp/specfem3d/specfem3d_globe/DATA/QRFSI12     /docker/run/DATA/.
RUN 	cp /tmp/specfem3d/specfem3d_globe/DATA/STATIONS       /docker/run/DATA/.
RUN 	cp -r /tmp/specfem3d/specfem3d_globe/DATA/s362ani     /docker/run/DATA/.
RUN 	cp -r /tmp/specfem3d/specfem3d_globe/DATA/topo_bathy  /docker/run/DATA/.
RUN 	cp /tmp/specfem3d/specfem3d_globe/bin/xmeshfem3D 	/docker/run/bin/.
RUN 	cp /tmp/specfem3d/specfem3d_globe/bin/xspecfem3D 	/docker/run/bin/.
COPY    Dockerfile  /docker/src/
COPY    data/run.sh /
# moved from run.sh (run_this_example.sh): as backup  in output dir
RUN 	mkdir -p /docker/run/DATABASES_MPI
RUN	mkdir -p /docker/run/OUTPUT_FILES
RUN	pwd && ls
RUN	cp /docker/run/DATA/Par_file 	/docker/run/OUTPUT_FILES/
RUN	cp /docker/run/DATA/STATIONS  	/docker/run/OUTPUT_FILES/
RUN	cp /docker/run/DATA/CMTSOLUTION /docker/run/OUTPUT_FILES/

#RUN     groupadd -r hpc_user && useradd -r -g hpc_user hpc_user
#USER    hpc_user

ENTRYPOINT sh "/run.sh"
 



# These are the run steps: to be moved to docker_run.sh
#RUN cd  /specfem3d_globe/EXAMPLES/regional_MiddleEast/ && mkdir bin
#RUN ls  /specfem3d_globe/EXAMPLES/regional_MiddleEast/bin/ && cp /specfem3d_globe/bin/* /specfem3d_globe/EXAMPLES/regional_MiddleEast/bin/
#RUN cd  /specfem3d_globe/EXAMPLES/regional_MiddleEast &&  ./run_this_example.sh
#RUN cd  /specfem3d_globe/EXAMPLES/regional_MiddleEast && tail  OUTPUT_FILES/output_mesher.txt && tail OUTPUT_FILES/output_solver.txt


