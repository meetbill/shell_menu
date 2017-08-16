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
g_SUDO_CONFIG=/etc/sudoers


function create_sudouser()
{
	local g_USER_NAME=''
    local g_USER_PASSWD=''
    read -p "please input new username:)(if empty ,not adduser) " g_USER_NAME
    [[ -z ${g_USER_NAME}  ]] && return 0
	read -p "please input passwd:) " g_USER_PASSWD
    useradd ${g_USER_NAME}
    echo ${g_USER_PASSWD} | passwd --stdin ${g_USER_NAME}
    echo "${g_USER_NAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${g_USER_NAME}
    if [[ $? != 0 ]]
    then
        echo "Error: Privilege grant failed!"
    fi
    echo 'set over'
}

create_sudouser
