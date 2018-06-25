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


read -p  "port:" port
read -p  "interface:(default:xgbe0)" if_name
[[ -z ${if_name}  ]] && if_name=xgbe0
echo "[port]:$port [if_name]:$if_name"
Enter
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
intercept -i ${if_name} -F "tcp and src port $port" -d

