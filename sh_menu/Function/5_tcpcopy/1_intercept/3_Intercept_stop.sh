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


intercept_pid=$(ps -ef| grep intercept | grep -v grep |awk '{print $2}')
echo "[intercept_pid]:${intercept_pid}"

[[ ! -z ${intercept_pid} ]] &&  kill -15 ${intercept_pid}

