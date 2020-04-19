source ./env.sh

pushd ${BUILDDIR}

export PK_MODULE=kokkos_dslash

if [ -d ./build_${PK_MODULE}  ];
then
  rm -rf ./build_${PK_MODULE}
fi

mkdir  ./build_${PK_MODULE}
cd ./build_${PK_MODULE}


#export OMPI_CXX=$HOME/bin/nvcc_wrapper
CXX="${PK_CXX}" CC="${PK_CC}" CXXFLAGS="${PK_CXXFLAGS}" cmake \
    -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8 \
    -DCMAKE_ECLIPSE_VERSION=4.5.0 \
    -G"Eclipse CDT4 - Unix Makefiles" \
    -DKOKKOS_ENABLE_OPENMP="ON" \
    -DKOKKOS_ARCH="ARMv8-TX2" \
    -DQDPXX_DIR=${INSTALLDIR}/qdp++-scalar/share \
    -DMG_USE_AVX512=OFF \
    -DMG_USE_AVX2=OFF \
    -DMG_DEFAULT_LOGLEVEL=DEBUG \
    -DCMAKE_BUILD_TYPE=DEBUG \
     ${SRCDIR}/KokkosDslash

${MAKE}
#-G"Eclipse CDT4 - Unix Makefiles" \                                              ------------------------------------------------------------------------------------|      -DCMAKE_ECLIPSE_MAKE_ARGUMENTS=-j8
