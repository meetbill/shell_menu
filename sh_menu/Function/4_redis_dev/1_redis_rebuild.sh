#!/bin/bash
#########################################################################
# File Name: redis_rebuild.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 10:28:34
#########################################################################

#yum install -y gcc make gcc-c++

# wget http://download.redis.io/releases/redis-2.8.24.tar.gz

set -e 
CUR_DIR=$(cd `dirname $0`; pwd)
cd ${CUR_DIR}
tar zxvf redis-2.8.24.tar.gz
cd redis-2.8.24
make


source ${CUR_DIR}/redis.config
mkdir  -p ${redis_dir}/bin/
cp src/redis-benchmark ${redis_dir}/bin/
cp src/redis-check-aof ${redis_dir}/bin/
cp src/redis-check-dump ${redis_dir}/bin/
cp src/redis-cli ${redis_dir}/bin/
cp src/redis-sentinel ${redis_dir}/bin/
cp src/redis-server ${redis_dir}/bin/

cat >${redis_dir}/redis.conf<<EOF
daemonize yes
port 6379
timeout 60
loglevel warning
databases 16
EOF
echo "ok"
cd ${CUR_DIR}
[[ -d redis-2.8.24 ]] && rm -rf redis-2.8.24
