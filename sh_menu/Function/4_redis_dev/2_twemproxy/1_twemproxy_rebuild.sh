#!/bin/bash
#########################################################################
# File Name: twemproxy_rebuild.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2018-03-09 10:28:34
#########################################################################

#yum install -y gcc make gcc-c++

# wget http://download.redis.io/releases/redis-2.8.24.tar.gz

set -e 
CUR_DIR=$(cd `dirname $0`; pwd)
cd ${CUR_DIR}
TWEMTPOXY=twemproxy-0.2.4
tar zxf ${TWEMTPOXY}.tar.gz 
cd ${TWEMTPOXY}
autoreconf -fvi
./configure --enable-debug=log
make

twemproxy_dir=~/twemproxy_meetbill
mkdir -p ${twemproxy_dir}/bin
cp src/nutcracker ${twemproxy_dir}/bin
cat >${twemproxy_dir}/nutcracker.yml<<EOF
meetbill:
  listen: 0.0.0.0:6379
  hash: fnv1a_64
  distribution: ketama
  auto_eject_hosts: true
  redis: true 
  server_retry_timeout: 2000
  server_failure_limit: 1
  servers:
   - 127.0.0.1:6380:1 server1
   - 127.0.0.1:6381:1 server2
EOF
echo "ok"
cd ${CUR_DIR}
[[ -d ${TWEMTPOXY} ]] && rm -rf ${TWEMTPOXY}
