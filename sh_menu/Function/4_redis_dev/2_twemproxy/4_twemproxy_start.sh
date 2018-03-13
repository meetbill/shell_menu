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

twemproxy_dir=~/twemproxy_meetbill
if [[ ! -d ${twemproxy_dir} ]]
then
    echo "not found ${twemproxy_dir}"
    exit 1
fi


echo -e "\033[44;37m [proxy_dir]\033[0m"
proxy_dir_port=$(ls -al ${twemproxy_dir} | awk '/proxy_/{print $9}' | tr -d "proxy_" )
echo ${proxy_dir_port}

#echo -e "\033[44;37m [redis_started]\033[0m"
#if [ `id -u` -eq 0  ];
#then
#    redis_run_port=$(netstat  -tanp | grep 'redis-s' | awk '{print $4}'|awk -F: '{print $2}'|uniq)
#else
#    redis_run_port=$(sudo netstat  -tanp | grep 'redis-s' | awk '{print $4}'|awk -F: '{print $2}'|uniq)
#fi
#echo ${redis_run_port}
read -p  "port_start:" num1
read -p  "port_end:" num2
Enter
for ((n=$num1;n<=$num2;n++))
do
    echo "port:$n"
    check_proxy_dir=$(echo ${proxy_dir_port}|grep $n |wc -l)
    if [[ "w${check_proxy_dir}" == "w0" ]]
    then
        echo -e "\033[41;37m not found the dir $n \033[0m"
        continue
    fi
    source ${twemproxy_dir}/proxy_$n/proxy_config
    ${twemproxy_dir}/bin/nutcracker -d -c ${config_file} -p ${pid_file} -o ${log_file} -s ${moniter_port}
done
