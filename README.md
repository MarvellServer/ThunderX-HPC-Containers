# ThunderX HPC Container Recipes

This repo contains recipes to build and run docker containers of HPC
applications on Marvell ThunderX Processors. 

The recipes builds the containers in a modular way by taking advantage of the 
multistage builds in Dockers. The recipes reduce the build time by building
common components across applications only once. Also the recipes strive to
reduce the size of the final docker image by removing unnecessary build
components from the image and by squashing the final docker image.

The recipes are organised in the following directory structure.
```
├─── Distro1
│    ├─── build.sh
│    ├─── base
│    │    ├─── Dockerfile.base1
│    │    └─── Dockerfile.base2
│    ├─── libs
│    │    ├─── Dockerfile.lib1
│    │    └─── Dockerfile.lib2
│    └─── apps
│         ├─── app1
│         │    ├─── Dockerfile.app1
│         │    └─── config
│         └─── app1
│              ├─── Dockerfile.app1
│              └─── config
└─── Distro2
     ├─── build.sh
     ├─── base
     │    ├─── Dockerfile.base1
     │    └─── Dockerfile.base2
     ├─── libs
     │    ├─── Dockerfile.lib1
     │    └─── Dockerfile.lib2
     └─── apps
          ├─── app1
          │    ├─── Dockerfile.app1
          │    └─── config
          └─── app1
               ├─── Dockerfile.app1
               └─── config
```

At the top level, the distro directories are present which contains the recipes
for the respective distros. Currently recipes for Ubuntu 18.04 and Centos 8 are
available.

Under each distro, directories named *base*, *libs* and *apps* are present
which contains dockerfiles for base image, libraries and applications
respectively. The base dockerfiles defines the container for base images 
*Eg: CUDA 11 base image*. The base containers needs to be build independently
using *docker build* command.

The library dockerfiles uses the base image to build containers for a particular
library. There are two special library dockerfiles named with suffixes *devel*
and *runtime* which defines a particular build and runtime environment
respectively *Eg: GCC 9 environment*. The application dockerfiles make use of
the library dockerfiles to get the components that are required for building the
applications. A file named *config* is present in each application directory
which defines the required components for the particular application.

A *build.sh* bash script is provided under each distro which can be used to
build the application containers. This scripts read the config file for the
application and builds the necessary depedent library containers as well as the
application containers. Due to the properties of the multistage docker builds,
library containers which are already built are not re-built effectively reduing
build time.

To build an application container run the *build.sh* script as follows.

```
./build.sh APP_NAME
```

Eg:

```
./build.sh hpl
./build.sh gromacs/cpu
./build.sh lammps/gpu
```

