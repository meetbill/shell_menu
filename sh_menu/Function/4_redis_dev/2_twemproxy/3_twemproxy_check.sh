#!/bin/bash
#########################################################################
# File Name: 3_redis_check.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 16:39:14
#########################################################################
if [ `id -u` -eq 0  ];
then
    netstat -tanp | grep nutcracker | grep "0.0.0.0"
else
    sudo netstat -tanp | grep nutcracker | grep "0.0.0.0"
fi
