#########################################################################
# File Name: login.sh
# Author: Bill
# mail: XXXXXXX@qq.com
# Created Time: 2016-08-06 01:25:55
#########################################################################
#!/bin/bash
CUR_DIR=$(cd `dirname $0`; pwd)
cd ${CUR_DIR}
cat /var/log/secure | awk '/Accepted password/{print $0 $(NF-3)}' |awk 'BEGIN{split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec",k," ");for(i=1;i<13;i++){m[k[i]]=i}}{$1=m[$1];print "/"$1"/"$2" "$3" "$(NF-5)" "$(NF-3)" ""Password"}' >/tmp/login.log
cat /var/log/secure | awk '/Accepted publickey/{print $0 $(NF-3)}' |awk 'BEGIN{split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec",k," ");for(i=1;i<13;i++){m[k[i]]=i}}{$1=m[$1];print "/"$1"/"$2" "$3" "$(NF-5)" "$(NF-3)" ""Key"}'>>/tmp/login.log
cat /tmp/login.log | while read myline
do 
    echo -n $myline
    IP=`echo $myline | awk  '{print $4}'`
    SITE=`python ./query_ip.py ${IP}` 
    echo "-----"$SITE
done
