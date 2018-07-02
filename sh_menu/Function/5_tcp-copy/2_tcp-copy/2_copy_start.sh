#!/bin/bash
#########################################################################
# File Name: 2_intercept_start.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 16:40:35
#########################################################################
#set -e 
#set -o pipefail 
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
tcpcopy_check=$(ps -ef | grep tcpcopy | grep -v grep)
[[ ! -z ${tcpcopy_check} ]] && echo "have tcpcopy process"

install_dir=/root/tcp_copy
read -p  "source_port:" source_port
read -p  "dest_ip:" dest_ip
read -p  "dest_port:" dest_port
read -p  "multiple:" multiple
echo "[source_port:]$source_port [dest_ip:]$dest_ip [dest_port]:$dest_port [multiple:]${multiple}"

Enter
${install_dir}/sbin/tcpcopy -x ${source_port}-${dest_ip}:${dest_port} -s ${dest_ip} -c 192.168.2.x -n ${multiple} -d
