#!/bin/bash
#########################################################################
# File Name: 5_redis_stop.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 16:42:28
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


netstat -tanp | grep redis-s | grep "0.0.0.0"

echo -e "\033[44;37m [redis_started]\033[0m"
redis_run_port=$(netstat  -tanp | grep 'redis-s' | awk '{print $4}'|awk -F: '{print $2}'|uniq)
echo ${redis_run_port}
read -p  "port_start:" num1
read -p  "port_end:" num2
Enter
for ((n=$num1;n<=$num2;n++))
do
    echo "port:$n ok"
    ${redis_dir}/bin/redis-cli -h 127.0.0.1 -p $n shutdown
done
