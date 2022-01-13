# GCC toolchain Builder

This is a set of bash scripts for build gcc toolchain on a unix environment 
## Build the toolchain

First, you need to install devel environment was come with your Linux distro for build the toolchain. 

**ArchLinux**
```bash
$ sudo pacman -Syu
$ sudo pacman -S base-devel
```

**Debian**
```bash
$ sudo apt update
$ sudo apt install build-essential textinfo
```

**Ubuntu**
```bash
$ sudo apt update
$ sudo apt install build-essential textinfo
```

**Fedora**
```bash
$ sudo dnf update
$ sudo dnf groupinstall "Development Tools"
$ sudo dnf groupinstall "C Development Tools and Libraries"
```

After, going into your workspace where you want build the toolchain (for example ~/workspace/source) and clone this repository:

```bash
cd ~/workspace/source
git clone https://github.com/testtube123/gcc-toolchain-build.git
cd *-elf-gcc
```
Now, you can run **build-toolchain.sh** for start the build. The process should take approximately 15 min or several hours depending on your computer. **Please, don't run this script as root!**

```bash
$ ./build-toolchain.sh
```

For build the toolchain with the newlib, use `--with-newlib` argument:

```bash
$ ./build-toolchain.sh --with-newlib /* Have Not Tested */
```

For build the toolchain with other processors use `--with-cpu` argument:

```bash
$ ./build-toolchain.sh --with-cpu=...
```

For change the program prefix, use `--program-prefix` argument:

```bash
$ ./build-toolchain.sh --program-prefix=*-
```

## Install

Once the toolchain was successful built, you can process to the installation. Move or copy the "*-toolchain" folder in "/opt" or "/usr/local":

```bash
$ sudo cp -R *-toolchain /opt
```

If you want, add the toolchain to your path environment:

```bash
$ echo export PATH="${PATH}:/opt/*-toolchain/bin" >> ~/.bashrc
$ source ~/.bash_profile
```

Finally, check that *-elf-gcc is working properly:

```bash
$ *-elf-gcc -v
```

The result should display something like this:

```bash
Using built-in specs.
COLLECT_GCC=./*-elf-gcc
COLLECT_LTO_WRAPPER=/home/kentosama/Workspace/*-elf-gcc/*-toolchain/libexec/gcc/*-elf/11.1.0/lto-wrapper
Target: *-elf
Configured with: ../../source/gcc-11.1.0/configure --prefix=/home/example/Workspace/*-elf-gcc/*-toolchain --build=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu --target=*-elf --program-prefix=*-elf- --enable-languages=c --enable-obsolete --enable-lto --disable-threads --disable-libmudflap --disable-libgomp --disable-nls --disable-werror --disable-libssp --disable-shared --disable-multilib --disable-libgcj --disable-libstdcxx --disable-gcov --without-headers --without-included-gettext --with-cpu=*
Thread model: single
gcc version 11.1.0 (GCC) 
```

For backup, you can store the toolchain in external drive:
```bash
$ tar -Jcvf sh2-gcc-11.1.0-toolchain.tar.xz *-toolchain
$ mv *-gcc-11.1.0-toolchain.tar.xz /storage/toolchains/
```
