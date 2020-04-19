#-------------------------------------------------------------------------------
#
#  linux_x86_64_gnu_noxml.mk
#
#-------------------------------------------------------------------------------
# $Id: linux_x86_64_intel.mk,v 1.1 2010/01/22 00:35:01 draeger1 Exp $
#
 PLT=LINUX_X86_64_GNU
#-------------------------------------------------------------------------------
 FFTWDIR=/usr/local
 FFTWLIB=$(FFTWDIR)/lib/libfftw3.a
# BLASDIR=$(HOME)/software/blas/blas-linux_x86-64
# LAPACKDIR=$(HOME)/software/lapack/lapack-linux_x86-64
XERCESCDIR=/usr/local
 SCALAPACK_DIR =/usr/local
 SCALAPACKLIB  = $(SCALAPACK_DIR)/lib/libscalapack.so
 BLASDIR=/usr/local
 CXX=mpic++
 LD=$(CXX)

 DFLAGS +=-DUSE_XERCES -DUSE_FFTW3 -DUSE_CSTDIO_LFS -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DIA32 -DUSE_MPI -DSCALAPACK -DADD_ -DAPP_NO_THREADS -DXML_USE_NO_THREADS -DXERCESC_3 -DMPICH_IGNORE_CXX_SEEK
 
 INCLUDE = -I$(FFTWDIR)/include -I${BLASDIR}/include -I$(XERCESCDIR)/include
 export CFLAGS=-g -O3 -funroll-all-loops -mcpu=thunderx2t99 -march=armv8.1-a+lse -ffast-math -fpermissive -fopenmp -DUSE_MPI -DSCALAPACK -DADD_ -D$(PLT) $(INCLUDE) $(DFLAGS)
export CXXFLAGS=-g -O3 -funroll-all-loops -mcpu=thunderx2t99 -march=armv8.1-a+lse -ffast-math -fpermissive -fopenmp -DUSE_MPI -DSCALAPACK -DADD_ -D$(PLT) $(INCLUDE) $(DFLAGS)
 #CFLAGS= -g -Ofast -mcpu=thunderx2t99 -march=armv8.1-a+lse -ffast-math -fpermissive -fopenmp -DUSE_MPI -DSCALAPACK -DADD_ -D$(PLT) $(INCLUDE) $(DFLAGS)

# LIBPATH = -L$(FFTWDIR) -L$(BLASDIR) -L$(LAPACKDIR)
# LIBS =  $(SCALAPACKLIB) -lgfortran -lfftw -lblas -llapack 
 LIBPATH = -L$(BLASDIR)/lib 
 LIBS =  -L$(SCALAPACKLIB)  -L$(XERCESCDIR)/lib64 -L$(FFTWDIR)/lib -lfftw3 -lxerces-c -lopenblas -lscalapack -lpthread -g -O3 -fopenmp #-omp -openmp -lmkl_core -lmkl_gnu_thread -lmkl_gf_lp64

# LDFLAGS = $(LIBPATH) $(LIBS) -Wl,-rpath,/usr/local/tools/mkl-8.1.1.004/lib
LDFLAGS +=$(LIBPATH) $(LIBS)

#-------------------------------------------------------------------------------
