#!/bin/bash
#########################################################################
# File Name: audit_action.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2017-04-25 13:51:33
# 开启linux操作审计
#########################################################################

if [[ $(id -u) -eq 0 ]];
then
    FILENAME="/var/log/Command_history.log"
    PATHNAME="/etc/profile"
    FINDNAME="HISTORY_FILE"
    if [[ ! -f ${FILENAME} ]]
    then
        #创建行为审计日志文件
        touch ${FILENAME}
        #将日志文件的所有者改为权限低的用户NOBODY
        chown nobody:nobody ${FILENAME}
        #赋予所有用户对日志文件写的权限
        chmod 002 ${FILENAME}
        #使所有用户对日志文件只有追加权限
        chattr +a ${FILENAME}
    fi
else
    USER_HOME=$(echo ~)
    FILENAME="${USER_HOME}/.Command_history.log"
    PATHNAME="${USER_HOME}/.bashrc"
    FINDNAME="HISTORY_FILE"
fi


if [[ $(cat ${PATHNAME} | grep ${FINDNAME} | wc -l) -lt 1 ]]; then
    echo "export HISTORY_FILE=${FILENAME}" >> ${PATHNAME}
    cat >> ${PATHNAME} <<"EOF"
export PROMPT_COMMAND='{ date "+%y-%m-%d %T ##### $(who am i |awk "{print \$1\" \"\$2\" \"\$5}")  #### $(history 1 | { read x cmd; echo "$cmd"; })"; } >>${HISTORY_FILE}'
EOF
fi
echo "set over"
