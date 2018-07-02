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

f_yellow='\e[00;33m'
f_red='\e[00;31m'
f_green='\e[00;32m'
f_reset='\e[00;0m'

function p_warn {
    echo -e "${f_yellow}[wrn]${f_reset} ${1}"
}

function p_err {
    echo -e "${f_red}[err]${f_reset} ${1}"
}

function p_ok {
    echo -e "${f_green}[ok ]${f_reset} ${1}"
}

# check if user is root
if [ $(id -u) != "0" ]; then
    p_err "you must be root to run this script, please use root to install"
    exit 1
fi

install_dir=/root/tcp_copy

# 安装 libpcap
tar zxf ./libpcap-1.7.4.tar.gz
cd libpcap-1.7.4
./configure --prefix=${install_dir}
make
make install

# 安装 intercept
cd ${CUR_DIR}
tar zxf ./intercept-1.0.0.tar.gz
cp ./scripts/linux ./intercept-1.0.0/auto/
cp ./scripts/configure ./intercept-1.0.0/
cd intercept-1.0.0
export LD_LIBRARY_PATH=${install_dir}/lib:$LD_LIBRARY_PATH

./configure --prefix=${install_dir}
make
make install


cd ${CUR_DIR}
[[ -d libpcap-1.7.4 ]] && rm -rf libpcap-1.7.4
[[ -d intercept-1.0.0 ]] && rm -rf intercept-1.0.0
