#!/bin/bash
#########################################################################
# File Name: safe.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2017-04-27 10:49:54
#########################################################################

#{{{set_ssh_outtime
function set_ssh_outtime()
{
    echo "登录超时自动退出"
    #echo "set session time out terminal "
    tmout=`grep -i TMOUT /etc/profile`
    date=`date +%F`
    if [ ! -n "$tmout" ]
    then 
        echo
        echo -n "do you want to set login timeout to 300s? [yes]:"
        read i
        case $i in 
        y|yes)
            cp /etc/profile /etc/profile_$date
            echo "export TMOUT=300" >> /etc/profile
            . /etc/profile
            ;;
        n|no)
            break
            ;;
        *)
            echo "please input yes or no"
            ;;
        esac
    else 
        mesg=`echo $tmout |awk -F"=" '{print $2}'`
        if [ "$mesg" -ne 300 ]
        then
            echo "The login session timeout is $mesg now will change to 300 seconds"
            cp /etc/profile /etc/profile_$date
            echo "export TMOUT=300" >> /etc/profile
            . /etc/profile
        fi
    fi
    echo "set over"
}
#}}}
set_ssh_outtime
