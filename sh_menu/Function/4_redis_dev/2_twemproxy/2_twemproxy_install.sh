#!/bin/bash
#########################################################################
# File Name: redis_install.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 15:04:15
#########################################################################

set -e 
CUR_DIR=$(cd `dirname $0`; pwd)
cd ${CUR_DIR}

twemproxy_dir=~/twemproxy_meetbill
if [[ ! -d ${twemproxy_dir} ]]
then
    echo "not found ${twemproxy_dir}"
    exit 1
fi

read -p  "port_start:" num1
read -p  "port_end:" num2
### install
for ((n=$num1;n<=$num2;n++))
do
    echo "port:$n ok"
    mkdir -p ${twemproxy_dir}/proxy_$n/{run,conf,logs}
    cp ${twemproxy_dir}/nutcracker.yml  ${twemproxy_dir}/proxy_$n/conf/
    sed -i "s/6379/$n/g"  ${twemproxy_dir}/proxy_$n/conf/nutcracker.yml
    > ${twemproxy_dir}/proxy_$n/proxy_config
    echo "config_file=${twemproxy_dir}/proxy_$n/conf/nutcracker.yml" >> ${twemproxy_dir}/proxy_$n/proxy_config
    echo "pid_file=${twemproxy_dir}/proxy_$n/run/proxy.pid" >> ${twemproxy_dir}/proxy_$n/proxy_config
    echo "log_file=${twemproxy_dir}/proxy_$n/logs/proxy.log" >> ${twemproxy_dir}/proxy_$n/proxy_config
    echo "moniter_port=2$n" >> ${twemproxy_dir}/proxy_$n/proxy_config

done

echo "please config the config file"
