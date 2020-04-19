#. /usr/share/Modules/init/bash
TOPDIR=`pwd`

BUILDDIR=${TOPDIR}/build
INSTALLDIR=${TOPDIR}/install
SRCDIR=${TOPDIR}/src

PK_CXX="g++"
PK_CC="gcc"
#PK_CXX="mpic++"
#PK_CC="mpicc"
PK_OMP_ENABLE="--enable-openmp"
PK_CXXFLAGS="-g -O3 -fprefetch-loop-arrays -fopenmp -march=native -fpermissive"  
PK_CXXFLAGS_NVCC="$PK_CXXFLAG --expt-extended-lambda --expt-relaxed-constexpr"
PK_CFLAGS="-g -O3 -fprefetch-loop-arrays -std=gnu99 -march=native -fopenmp" 
#PK_LDFLAGS="${PK_CXXFLAGS_NVCC} -L/opt/arm/arm-hpc-compiler-19.3_Generic-AArch64_RHEL-7_aarch64-linux/lib -L${ARMPL_DIR}/lib -larmpl_lp64 -lamath -lsimdmath -lastring"
#PK_LIBS="-L/opt/arm/arm-hpc-compiler-19.3_Generic-AArch64_RHEL-7_aarch64-linux/lib -L${ARMPL_DIR}/lib -larmpl_lp64 -lamath -lsimdmath -lastring"

MAKE="make -j V=1 VERBOSE=1 v=1 "


