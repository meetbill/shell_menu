#!/bin/bash
#########################################################################
# File Name: change_sshd_port.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: 2017-04-25 13:51:33
#########################################################################

#判断系统版本
check_sys(){
	local checkType=$1
	local value=$2

	local release=''
	local systemPackage=''
	local packageSupport=''

	if [[ "$release" == "" ]] || [[ "$systemPackage" == "" ]] || [[ "$packageSupport" == "" ]];then

		if [[ -f /etc/redhat-release ]];then
			release="centos"
			systemPackage="yum"
			packageSupport=true

		elif cat /etc/issue | grep -q -E -i "debian";then
			release="debian"
			systemPackage="apt"
			packageSupport=true

		elif cat /etc/issue | grep -q -E -i "ubuntu";then
			release="ubuntu"
			systemPackage="apt"
			packageSupport=true

		elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
			release="centos"
			systemPackage="yum"
			packageSupport=true

		elif cat /proc/version | grep -q -E -i "debian";then
			release="debian"
			systemPackage="apt"
			packageSupport=true

		elif cat /proc/version | grep -q -E -i "ubuntu";then
			release="ubuntu"
			systemPackage="apt"
			packageSupport=true

		elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
			release="centos"
			systemPackage="yum"
			packageSupport=true

		else
			release="other"
			systemPackage="other"
			packageSupport=false
		fi
	fi

	if [[ $checkType == "sysRelease" ]]; then
		if [ "$value" == "$release" ];then
			return 0
		else
			return 1
		fi

	elif [[ $checkType == "packageManager" ]]; then
		if [ "$value" == "$systemPackage" ];then
			return 0
		else
			return 1
		fi

	elif [[ $checkType == "packageSupport" ]]; then
		if $packageSupport;then
			return 0
		else
			return 1
		fi
	fi
}

#获取版本号
versionget(){
	if [[ -s /etc/redhat-release ]];then
		grep -oE  "[0-9.]+" /etc/redhat-release
	else	
		grep -oE  "[0-9.]+" /etc/issue
	fi	
}

#判断centos版本
CentOSVerCheck(){
	if check_sys sysrelease centos;then
		local code=$1
		local version="`versionget`"
		local main_ver=${version%%.*}
		if [ $main_ver == $code ];then
			return 0
		else
			return 1
		fi
	else
		return 1
	fi
}

#验证端口合法性
verify_port(){
	local port=$1
	if echo $port | grep -q -E "^[0-9]+$";then
		if [[ "$port" -lt 0 ]] || [[ "$port" -gt 65535 ]];then
			return 1
		else
			return 0
		fi	
	else
		return 1
	fi		
}


#判断命令是否存在,不存在就退出
check_command_exist(){
    local command=$1
    IFS_SAVE="$IFS"
    IFS=":"
    local code
    for path in $PATH;do
        binPath="$path/$command"
        if [[ -f $binPath ]];then
    		IFS="$IFS_SAVE"
            return 0
        fi
    done
    IFS="$IFS_SAVE"
    echo "$command not found,please install it."
    exit 1

}

#更改ssh server端口
Change_sshd_port(){
	local listenPort=`netstat -nlpt | awk '/sshd/{print $4}' | grep -o -E "[0-9]+$" | awk 'NR==1{print}'`
	local configPort=`grep -v "^#" /etc/ssh/sshd_config | sed -n -r 's/^Port\s+([0-9]+).*/\1/p'`
	configPort=${configPort:=22}

	echo "the ssh server is listenning at port $listenPort."
	echo "the /etc/ssh/sshd_config is configured port $configPort."

	local newPort=''
	while true; do
		read -p "please input your new ssh server port(range 0-65535,greater than 1024 is recommended.): " newPort
		if verify_port "$newPort";then
			break
		else
			echo "input error,must be a number(range 0-65535)."
		fi
	done

	#备份配置文件
	echo "backup sshd_config to sshd_config_original..."
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config_original

	#开始改端口
	if grep -q -E "^Port\b" /etc/ssh/sshd_config;then
		sed -i -r "s/^Port\s+.*/Port $newPort/" /etc/ssh/sshd_config
	elif grep -q -E "#Port\b" /etc/ssh/sshd_config; then
		sed -i -r "s/#Port\s+.*/Port $newPort/" /etc/ssh/sshd_config
	else
		echo "Port $newPort" >> /etc/ssh/sshd_config
	fi
	
	#重启sshd
	local restartCmd=''
	if check_sys sysRelease debian || check_sys sysRelease ubuntu; then
		restartCmd="service ssh restart"
	else
		if check_sys sysRelease centos && CentOSVerCheck 7;then
			restartCmd="/bin/systemctl restart sshd.service"
		else	
			restartCmd="service sshd restart"
		fi	
	fi
	$restartCmd
	sleep 1

	#验证是否成功
	local nowPort=`netstat -nlpt | awk '/sshd/{print $4}' | grep -o -E "[0-9]+$" | awk 'NR==1{print}'`
	if [[ "$nowPort" == "$newPort" ]]; then
		echo "change ssh server port to $newPort successfully."
	else
		echo "fail to change ssh server port to $newPort."
		echo "rescore the backup file /etc/ssh/sshd_config_original to /etc/ssh/sshd_config..."
		\cp /etc/ssh/sshd_config_original /etc/ssh/sshd_config
		$restartCmd
	fi

	exit
}

Change_sshd_port
