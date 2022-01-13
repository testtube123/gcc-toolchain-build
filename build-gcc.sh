#!/bin/bash

###################################################################
#Script Name	:   build-gcc                                                                                           
#Description	:   build gcc for the Motorola 68000 toolchain   
#Date           :   Monday, 4 October 2021                                                                          
#Args           :   Welcome to the next level!                                                                                        
#Author       	:   Jacques Belosoukinski (kentosama)
#Fork Author    :   TestTube123
#Email         	:                                             
##################################################################

VERSION="11.1.0"
ARCHIVE="gcc-${VERSION}.tar.gz"
URL="https://gcc.gnu.org/pub/gcc/releases/gcc-${VERSION}/${ARCHIVE}"
DIR="gcc-${VERSION}"

# Check if user is root
if [ ${EUID} == 0 ]; then
    echo "Please don't run this script as root"
    exit
fi

# Create build folder
mkdir -p ${BUILD_DIR}/${DIR}

cd ${DOWNLOAD_DIR}

# Download gcc if is needed
if ! [ -f "${ARCHIVE}" ]; then
    wget ${URL}
fi

# Extract gcc archive if is needed
if ! [ -d "${SRC_DIR}/${DIR}" ]; then
    tar xzvf ${ARCHIVE} -C ${SRC_DIR}

    
fi

cd ${SRC_DIR}/${DIR}

echo ${PWD}

# Download prerequisites
./contrib/download_prerequisites

cd ${BUILD_DIR}/${DIR}

# Configure before build
../../source/${DIR}/configure   --prefix=${INSTALL_DIR}             \
                                --build=${BUILD_MACH}               \
                                --host=${HOST_MACH}                 \
                                --target=${TARGET}                  \
                                --program-prefix=${PROGRAM_PREFIX}  \
                                --enable-languages=c                \
                                --enable-obsolete                   \
                                --enable-lto                        \
                                --disable-threads                   \
                                --disable-libmudflap                \
                                --disable-libgomp                   \
                                --disable-nls                       \
                                --disable-werror                    \
                                --disable-libssp                    \
                                --disable-shared                    \
                                --disable-multilib                  \
                                --disable-libgcj                    \
                                --disable-libstdcxx                 \
                                --disable-gcov                      \
                                --without-headers                   \
                                --without-included-gettext          \
                                --with-cpu=${WITH_CPU}              \
                                ${WITH_NEWLIB}                      


# build and install gcc
make -j${NUM_PROC} 2<&1 | tee build.log

# Install
if [ $? -eq 0 ]; then
    make install
    make -j${NUM_PROC} all-target-libgcc
    make install-target-libgcc
fi


