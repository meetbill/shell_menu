#! /bin/bash


#{{{account_policy
function account_policy()
{
    ################################################################################
    # PASS_MAX_DAYS   99999     # 密码的最大有效期，99999: 永久有期
    # PASS_MIN_DAYS   0         # 是否可修改密码，0 可修改，非 0 多少天后可修改
    # PASS_MIN_LEN    5         # 密码最小长度，使用 pam_cracklib module, 该参数不再有效
    # PASS_WARN_AGE   7         # 密码失效前多少天在用户登录时通知用户修改密码
    #################################################################################

    echo "账号策略检查中..."
    passmax=`cat /etc/login.defs | grep PASS_MAX_DAYS | grep -v ^# | awk '{print $2}'`
    passmin=`cat /etc/login.defs | grep PASS_MIN_DAYS | grep -v ^# | awk '{print $2}'`
    passlen=`cat /etc/login.defs | grep PASS_MIN_LEN | grep -v ^# | awk '{print $2}'`
    passage=`cat /etc/login.defs | grep PASS_WARN_AGE | grep -v ^# | awk '{print $2}'`
    if [ $passmax -le 90 -a $passmax -gt 0 ];then
        echo "  [OK] 口令生存周期为 ${passmax}天，符合要求" >> ${safe_check_log}
    else
        echo "  [ X ] 口令生存周期为 ${passmax}天，不符合要求，建议设置不大于 90 天" >> ${safe_check_log}
    fi


    if [ $passmin -ge 6 ];then
        echo "  [OK] 口令更改最小时间间隔为 ${passmin}天，符合要求" >> ${safe_check_log}
    else
        echo "  [ X ] 口令更改最小时间间隔为 ${passmin}天，不符合要求，建议设置大于等于 6 天" >> ${safe_check_log}
    fi


    if [ $passlen -ge 8 ];then
        echo "  [OK] 口令最小长度为 ${passlen}, 符合要求" >> ${safe_check_log}
    else
        echo "  [ X ] 口令最小长度为 ${passlen}, 不符合要求，建议设置最小长度大于等于 8" >> ${safe_check_log}
    fi


    if [ $passage -ge 30 -a $passage -lt $passmax ];then
        echo "  [OK] 口令过期警告时间天数为 ${passage}, 符合要求" >> ${safe_check_log}
    else
        echo "  [ X ] 口令过期警告时间天数为 ${passage}, 不符合要求，建议设置大于等于 30 并小于口令生存周期" >> ${safe_check_log}
    fi
    echo 'check over'
}
#}}}
#{{{account_timeout
function account_timeout()
{
    echo "账号注销检查中..."

    TMOUT=`cat /etc/profile | grep TMOUT | awk -F[=] '{print $2}'`

    if [ ! $TMOUT ];then
        echo "  [ X ] 账号超时不存在自动注销，不符合要求，建议设置小于 600 秒，推荐 [05_account_timeout.sh]" >> ${safe_check_log}
    else
        if [ $TMOUT -le 600 -a $TMOUT -ge 10 ] ; then
            echo "  [ √ ] 账号超时时间 ${TMOUT}秒，符合要求" >> ${safe_check_log}
        else
            echo "  [ X ] 账号超时时间 $TMOUT 秒，不符合要求，建议设置小于 600 秒，推荐 [05_account_timeout.sh]" >> ${safe_check_log}
        fi
    fi
    echo 'check over'
}
#}}}
#{{{audit_action
function audit_action()
{
    echo "Linux 操作审计检查中..."

    HISTORY=`cat /etc/profile | grep HISTORY_FILE | wc -l`

    if [[ $HISTORY == 0 ]];then
        echo "  [ X ] 系统没有添加操作审计，不符合要求，建议 [03_AuditAction.sh]" >> ${safe_check_log}
    else
        echo "  [ √ ] 系统已添加操作审计，符合要求" >> ${safe_check_log}
    fi
    echo 'check over'
}
#}}}
#{{{deny_rootlogin
function deny_rootlogin()
{
    echo "检查 Linux root 用户是否可以登录..."

    rootlogin_check=`grep ^PermitRootLogin /etc/ssh/sshd_config| grep no| wc -l`

    if [[  $rootlogin_check == 0 ]];then
        echo "  [ X ] root 用户可以登录此系统，不符合要求，建议 [01_DenyRootLogin.sh]" >> ${safe_check_log}
    else
        echo "  [ √ ] 系统已禁止 root 用户登录，符合要求" >> ${safe_check_log}
    fi
    echo 'check over'
}
#}}}
#{{{rm_trash
function rm_trash()
{
    echo "检查 Linux rm 回收站命令..."

    if [[ ! -f /bin/rmtrash.sh ]];then
        echo "  [ X ] 此 linux 系统没有 rm 回收站功能, 不符合要求,建议 [06_rmtrash.sh]" >> ${safe_check_log}
    else
        echo "  [ √ ] 系统已开启 rm 回收站功能，符合要求" >> ${safe_check_log}
    fi
    echo 'check over'
}
#}}}

## 详细过滤脚本 待更新中...##
safe_check_log=/tmp/safe_check.log
> ${safe_check_log}

account_policy
account_timeout
audit_action
deny_rootlogin
rm_trash

echo -e "\n"
echo "--------------------------------------------------------------------------"
echo ""
echo "检查结果："
echo ""
cat ${safe_check_log}
echo ""
echo "--------------------------------------------------------------------------"
echo ""
