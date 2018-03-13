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

source ./redis.config

if [[ ! -d ${redis_dir} ]]
then
    echo "not found ${redis_dir}"
    exit 1
fi

read -p  "port_start:" num1
read -p  "port_end:" num2
### install
for ((n=$num1;n<=$num2;n++))
do
    echo "port:$n ok"
    mkdir -p ${redis_dir}/redis_$n
    cp ${redis_dir}/redis.conf  ${redis_dir}/redis_$n/
    sed -i "s/6379/$n/g"  ${redis_dir}/redis_$n/redis.conf
    #${redis_dir}/bin/redis-server ${redis_dir}/redis_$n/redis.conf
done
