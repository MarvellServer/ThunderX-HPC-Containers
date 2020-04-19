#!/bin/bash
#
#################
# BUILD QMP
#################
source ./env.sh

pushd ${SRCDIR}/qdpxx
autoreconf
popd

pushd ${BUILDDIR}

if [ -d ./build_qdp++-scalar ]; 
then 
  rm -rf ./build_qdp++-scalar
fi

mkdir  ./build_qdp++-scalar
cd ./build_qdp++-scalar


${SRCDIR}/qdpxx/configure \
	--prefix=${INSTALLDIR}/qdp++-scalar \
        --enable-parallel-arch=scalar \
	--disable-generics \
	--enable-db-lite \
	--enable-precision=double \
	--enable-largefile \
        --enable-dml-output-buffering \
	--enable-parallel-io \
	--with-libxml2=/usr/local/ \
	CXXFLAGS="${PK_CXXFLAGS}" \
	CFLAGS="${PK_CFLAGS}" \
	CXX="${PK_CXX}" \
	CC="${PK_CC}" \
	${PK_OMP_ENABLE} \
	--host=x86_64-linux-gnu --build=x86_64-linux-gnu

${MAKE}
${MAKE} install

popd
