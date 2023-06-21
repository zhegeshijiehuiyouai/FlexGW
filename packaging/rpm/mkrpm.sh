#!/bin/bash


#flexgw_refs="origin/master"
package_name="flexgw"
flexgw_version="1.2.0"
flexgw_release="1"
python_version="2.7.9"
python_dir="/usr/local/flexgw/python"

curdir=$(pwd)

if [ ! -f ./mkrpm.sh ]; then
    echo "请在 mkrpm.sh 所在的目录下执行脚本"
    exit 1
fi

#create necessary directories
mkdir -p /tmp/rpmbuild/SOURCES
mkdir -p /tmp/rpmbuild/PYTHON/cache
mkdir -p /tmp/rpmbuild/PYTHON/sources

[ -d /tmp/rpmbuild/SOURCES/flexgw ] && rm -rf /tmp/rpmbuild/SOURCES/flexgw

#clone repositories
# git clone https://github.com/zhegeshijiehuiyouai/FlexGW.git /tmp/rpmbuild/SOURCES/flexgw
dname=dname=${curdir%/*}
dname=${dname%/*}
# 项目根目录名
p_root_dir=${dname##*/}
cd ../../../
cp -ar ${p_root_dir} /tmp/rpmbuild/SOURCES/flexgw-$flexgw_version

#archive source from git repositories
cd /tmp/rpmbuild/SOURCES/
# git archive --format="tar" --prefix="$package_name-$flexgw_version/" $flexgw_refs|bzip2 > /tmp/rpmbuild/SOURCES/$package_name-$flexgw_version.tar.bz2
tar -zcf $package_name-$flexgw_version.tar.gz flexgw-$flexgw_version

# rpmbuild
cd $curdir
rpmbuild --define "_topdir /tmp/rpmbuild" \
--define "package_name $package_name" \
--define "version $flexgw_version" \
--define "release $flexgw_release" \
--define "python_version $python_version" \
--define "python_dir $python_dir" \
--define "curdir $curdir" \
-bb $curdir/flexgw.spec

rm -rf /tmp/rpmbuild/SOURCES
rm -rf /tmp/rpmbuild/BUILD
