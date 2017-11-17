#!/bin/bash
#########################################################################
# File Name: create_user.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2017-04-26 18:17:44
# 创建普通用户并禁止root用户登录
#########################################################################

#新建的用户名及密码
#g_USER_NAME='test'
#g_USER_PASSWD='itnihao'

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi
g_SSHD_CONFIG=/etc/ssh/sshd_config

function deny_rootlogin()
{
    sed -i 's/^#PermitRootLogin.*$/PermitRootLogin no/g' $g_SSHD_CONFIG
    sed -i 's/^PermitRootLogin.*$/PermitRootLogin no/g' $g_SSHD_CONFIG
    if [[ -e "/etc/init.d/sshd"  ]]
    then
        /etc/init.d/sshd restart
    else
        systemctl restart sshd
    fi
    echo 'set over'
}

deny_rootlogin
