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

tar zxf ./tcpcopy-1.1.0.tar.gz
cd tcpcopy-1.1.0
./configure --prefix=/usr/local/
make
make install


cd ${CUR_DIR}
[[ -d tcpcopy-1.1.0 ]] && rm -rf tcpcopy-1.1.0
