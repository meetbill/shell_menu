#!/bin/bash
#########################################################################
# File Name: 2_intercept_stop.sh
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
tcpcopy_pid=$(ps -ef| grep tcpcopy | grep -v grep |awk '{print $2}')
echo "[tcpcopy_pid]:${tcpcopy_pid}"

[[ ! -z ${tcpcopy_pid} ]] &&  kill -15 ${tcpcopy_pid}

