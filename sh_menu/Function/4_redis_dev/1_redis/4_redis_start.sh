#!/bin/bash
#########################################################################
# File Name: 4_redis_start.sh
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

source ./redis.config

if [[ ! -d ${redis_dir} ]]
then
    echo "not found ${redis_dir}"
    exit 1
fi


echo -e "\033[44;37m [redis_dir]\033[0m"
redis_dir_port=$(ls -al ${redis_dir} | awk '/redis_/{print $9}' | tr -d "redis_" )
echo ${redis_dir_port}

echo -e "\033[44;37m [redis_started]\033[0m"
if [ `id -u` -eq 0  ];
then
    redis_run_port=$(netstat  -tanp | grep 'redis-s' | awk '{print $4}'|awk -F: '{print $2}'|uniq)
else
    redis_run_port=$(sudo netstat  -tanp | grep 'redis-s' | awk '{print $4}'|awk -F: '{print $2}'|uniq)
fi
echo ${redis_run_port}
read -p  "port_start:" num1
read -p  "port_end:" num2
Enter
for ((n=$num1;n<=$num2;n++))
do
    echo "port:$n"
    check_redis_dir=$(echo ${redis_dir_port}|grep $n |wc -l)
    if [[ "w${check_redis_dir}" == "w0" ]]
    then
        echo -e "\033[41;37m not found the dir $n \033[0m"
        continue
    fi
    ${redis_dir}/bin/redis-server ${redis_dir}/redis_$n/redis.conf
done
