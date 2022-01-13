#!/bin/bash

###################################################################
#Script Name	:   build-toolchain                                                                                            
#Description	:   build the toolchain
#Date           :   Wednesday, 12 January 2022                                                                         
#Args           :   Welcome to the next level!                                                                                        
#Author       	:   Jacques Belosoukinski (kentosama)                                                   
#Email         	:                                      
#Fork Author    :   TestTube123
###################################################################

BUILD_BINUTILS="yes"
BUILD_GCC_STAGE_1="yes"
BUILD_GCC_STAGE_2="yes"
BUILD_NEWLIB="yes"
CPU="7400"
PREFIX="powerpc-elf-"

# Check if user is root
if [ ${EUID} == 0 ]; then
    echo "Please don't run this script as root!"
    exit
fi

# Check all args
i=1

for arg do
    if [[ "$arg" == "--with-newlib" ]]; then
        ${BUILD_NEWLIB}="yes"
        ${BUILD_GCC_STAGE_2}="yes"
        export WITH_NEWLIB="--with-newlib"
    elif [[ "$arg" == "--with-cpu=" ]]; then
        ${CPU} = ${i}
    elif [[ "$arg" == "--program-prefix=" ]]; then
        ${PREFIX} = ${i}
    fi

    i=$((i + 1))
done

# Export
export ARCH=$(uname -m)
export TARGET="powerpc-elf"
export BUILD_MACH="${ARCH}-pc-linux-gnu"
export HOST_MACH="${ARCH}-pc-linux-gnu"
export NUM_PROC=$(nproc)
export PROGRAM_PREFIX=${PREFIX}
export INSTALL_DIR="${PWD}/powerpc-toolchain"
export DOWNLOAD_DIR="${PWD}/download"
export ROOT_DIR="${PWD}"
export BUILD_DIR="${ROOT_DIR}/build"
export SRC_DIR="${ROOT_DIR}/source"
export WITH_CPU=${CPU}

# Create main folders in the root dir
mkdir -p ${INSTALL_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${SRC_DIR}
mkdir -p ${DOWNLOAD_DIR}

export PATH=$INSTALL_DIR/bin:$PATH

# Build binutils
if [ ${BUILD_BINUTILS} == "yes" ]; then
    ./build-binutils.sh
    if [ $? -ne 0 ]; then
        "Failed to build binutils, please check build.log"
        exit 1
    fi
fi

# Build GCC stage 1
if [ ${BUILD_GCC_STAGE_1} == "yes" ]; then
    ./build-gcc.sh
    if [ $? -ne 0 ]; then
        "Failed to build gcc stage 1, please check build.log"
        exit
    fi
fi

# Build newlib
if [ ${BUILD_NEWLIB} == "yes" ]; then
    ./build-newlib.sh
    if [ $? -ne 0 ]; then
        "Failed to build newlib, please check build.log"
        exit
    else
        # Build GCC stage 2 (with newlib)
        if [ ${BUILD_GCC_STAGE_2} == "yes" ]; then
            ./build-gcc.sh
            if [ $? -ne 0 ]; then
                "Failed to build gcc stage 2, please check build.log"
                exit
            fi
        fi
    fi
fi

echo ${TARGET} "toolchain build was terminated"
