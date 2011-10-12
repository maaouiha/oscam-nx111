#!/bin/sh

plat=mipsel
plat_dir=build_mipsel

rm -f oscam oscam-nx111  oscam-$plat-svn*.tar.gz
export OLDPATH=$PATH
export PATH=../../toolchains/mipsel-unknown-linux-gnu/bin:$OLDPATH     # 指定编译源码时要用的mipsel环境下的GCC和C++编译器路径
make clean
cmake -DCMAKE_TOOLCHAIN_FILE=../toolchains/toolchain-mips-tuxbox.cmake -DWEBIF=1 ..    #用cmake命令对源码进行交叉编译
make
export PATH=$OLDPATH
cp oscam oscam-release

[ -d image/usr/bin ] || mkdir -p image/usr/bin
cp oscam image/usr/bin/

curdir=`pwd`
builddir=`dirname $0`
[ "$builddir" = "." ] && svnroot=".."
[ "$builddir" = "." ] || svnroot=`dirname $builddir`
svnver=`svnversion  -c ${svnroot} | cut -f 2 -d: | sed -e "s/[^[:digit:]]//g"`
cd ${svnroot}/${plat_dir}/image
tar czf ../oscam-${plat}-svn${svnver}-nx111-`date +%Y%m%d`.tar.gz *
cd ../ 
rm -rf CMake* *.a Makefile cscrypt csctapi *.cmake algo image/usr/bin/oscam
cd $curdir
