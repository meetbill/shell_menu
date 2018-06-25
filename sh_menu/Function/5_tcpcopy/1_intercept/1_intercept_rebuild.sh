#!/bin/bash
#########################################################################
# File Name: intercept_rebuild.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 10:28:34
#########################################################################

set -e 
CUR_DIR=$(cd `dirname $0`; pwd)
cd ${CUR_DIR}

# 安装 libpcap
tar zxf ./libpcap-1.7.4.tar.gz
cd libpcap-1.7.4
./configure --prefix=/usr/local/
make
make install

# 安装 intercept
cd ${CUR_DIR}
tar zxf ./intercept-1.0.0.tar.gz
cp ./scripts/linux ./intercept-1.0.0/auto/
cp ./scripts/configure ./intercept-1.0.0/
cd intercept-1.0.0
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

./configure --prefix=/usr/local/
make
make install


cd ${CUR_DIR}
[[ -d libpcap-1.7.4 ]] && rm -rf libpcap-1.7.4
[[ -d intercept-1.0.0 ]] && rm -rf intercept-1.0.0
