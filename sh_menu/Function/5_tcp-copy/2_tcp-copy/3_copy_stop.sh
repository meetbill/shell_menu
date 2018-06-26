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

tcpcopy_pid=$(ps -ef| grep tcpcopy | grep -v grep |awk '{print $2}')
echo "[tcpcopy_pid]:${tcpcopy_pid}"

[[ ! -z ${tcpcopy_pid} ]] &&  kill -15 ${tcpcopy_pid}

