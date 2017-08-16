#!/bin/bash
#########################################################################
# File Name: 06_rmtrash.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2017-05-31 21:52:15
#########################################################################
CUR_DIR=$(cd `dirname $0`; pwd)
cd ${CUR_DIR}
# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi

cp ./rmtrash/rmtrash.sh_tpl /bin/rmtrash.sh
chmod +x /bin/rmtrash.sh
source ~/.bashrc
echo "set over"
