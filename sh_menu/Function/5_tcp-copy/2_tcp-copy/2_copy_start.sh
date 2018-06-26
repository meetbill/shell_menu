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

tcpcopy_check=$(ps -ef | grep tcpcopy | grep -v grep)
[[ ! -z ${tcpcopy_check} ]] && echo "have tcpcopy process"

read -p  "source_port:" source_port
read -p  "dest_ip:" dest_ip
read -p  "dest_port:" dest_port
read -p  "multiple:" multiple
echo "[source_port:]$source_port [dest_ip:]$dest_ip [dest_port]:$dest_port [multiple:]${multiple}"

Enter
tcpcopy -x ${source_port}-${dest_ip}:${dest_port} -s ${dest_ip} -c 192.168.2.x -n ${multiple} -d
