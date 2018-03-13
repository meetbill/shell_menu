#!/bin/bash
#########################################################################
# File Name: 6_redis_uninstall.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 17:21:33
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

echo -e "\033[44;37m [redis_started]\033[0m"
if [ `id -u` -eq 0  ];
then
    redis_run_port=$(netstat  -tanp | grep 'redis-s' | awk '{print $4}'|awk -F: '{print $2}'|uniq)
else
    redis_run_port=$(sudo netstat  -tanp | grep 'redis-s' | awk '{print $4}'|awk -F: '{print $2}'|uniq)
fi
echo ${redis_run_port}

function stop_redis()
{
    for n in $redis_run_port
    do
        echo "port:$n ok"
        ${redis_dir}/bin/redis-cli -h 127.0.0.1 -p $n shutdown
    done
}
while [[ 1 == 1 ]]
do
    read -r -p "Are You Sure? [Y/n] " input

    case $input in
        [yY][eE][sS]|[yY])
            echo "Yes"
            stop_redis
            [[ -d ${redis_dir} ]] && rm -rf ${redis_dir}
            break
            ;;

        [nN][oO]|[nN])
            echo "No"
            break
            ;;

        *)
        echo "Invalid input..."
        ;;
    esac
done
