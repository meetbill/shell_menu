#!/bin/bash
#########################################################################
# File Name: 2_intercept_start.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 16:40:35
#########################################################################
set -e 
#{{{Enter
Enter()
{
	echo
	printf "Press the Enter key to continue..."
	read -s Enter
	echo
}

#}}}
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
read -p  "port:" port
read -p  "interface:(default:xgbe0)" if_name
[[ -z ${if_name}  ]] && if_name=xgbe0
echo "[port]:$port [if_name]:$if_name"
Enter
install_dir=/root/tcp_copy
export LD_LIBRARY_PATH=${install_dir}/lib:$LD_LIBRARY_PATH

${install_dir}/sbin/intercept -i ${if_name} -F "tcp and src port $port" -d

