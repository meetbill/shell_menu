#!/bin/bash      
#########################################################################
# File Name: config.sh
# Author: meetbill
# mail: meetbill@163.com
# Created Time: Thu 06 Nov 2016 06:31:50 PM CST
#########################################################################
#Define Path    
DIR_BASE=$(cd `dirname $0`; pwd)
FILE_PIP_TAR=${DIR_BASE}/pip/pip*
FILE_TOOLS_TAR=${DIR_BASE}/pip/setup*

function Install()      
{   
	clear
	CK_DIR=`ls /opt -l | grep ^d | grep pip | wc -l`
	if [ "w${CK_DIR}" = "w1" ]
	then
		DIR_PIP=`ls /opt| grep  pip`
		echo ${DIR_PIP}
		cd /opt/${DIR_PIP}
		python setup.py install
	else
		tar -zxf ${FILE_TOOLS_TAR} -C /opt
		DIR_SETUPTOOLS=`ls /opt| grep  setuptools`
		echo ${DIR_SETUPTOOLS}
		cd /opt/${DIR_SETUPTOOLS} 
		python setup.py install
		
		cd ${DIR_BASE}
		tar -zxf ${FILE_PIP_TAR} -C /opt
		DIR_PIP=`ls /opt| grep  pip`
		echo ${DIR_PIP}
		cd /opt/${DIR_PIP} 
		python setup.py install
	fi
	
}      
Install 
          
