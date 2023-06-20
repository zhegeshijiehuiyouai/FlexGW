#!/bin/bash

# 带格式的echo函数
function echo_info() {
    echo -e "[\033[36m$(date +%T)\033[0m] [\033[32mINFO\033[0m] \033[37m$@\033[0m"
}
function echo_warning() {
    echo -e "[\033[36m$(date +%T)\033[0m] [\033[1;33mWARNING\033[0m] \033[1;37m$@\033[0m"
}
function echo_error() {
    echo -e "[\033[36m$(date +%T)\033[0m] [\033[41mERROR\033[0m] \033[1;31m$@\033[0m"
}

################ 预检测 ################
if [[ $(whoami) != 'root' ]];then
    echo_error 请使用root用户执行
    exit 1
fi


################ 内核参数 ################
echo_info 检查内核参数
sysctl_tag=0
flexgw_sysctl_file=/etc/sysctl.d/flexgw.conf
:>$flexgw_sysctl_file
sysctl_files=$(ls /etc/sysctl.d)
kernel_keys=$(sysctl -a 2>/dev/null | egrep "net.ipv4.*(accept|send)_redirects" | awk '{print $1}')
cd /etc/sysctl.d
for key in $kernel_keys;do
    # 针对每个key，进行判断
    key_tag=0
    for file in $sysctl_files;do
        grep $key $file &> /dev/null
        if [ $? -eq 1 ];then
            # 如果没有key，那么标记下
            key_tag=1
        fi
    done
    if [[ $key_tag -eq 1 ]];then
        sysctl_tag=1
        echo "$key = 0" >> $flexgw_sysctl_file
    fi
done
ip_forward=$(sysctl -a 2>/dev/null | grep "net.ipv4.ip_forward =" | awk '{print $3}')
if [[ $ip_forward -eq 0 ]];then
    sysctl_tag=1
    echo "net.ipv4.ip_forward = 1" >> $flexgw_sysctl_file
fi

if [[ $sysctl_tag -eq 1 ]];then
    echo_info 加载内核参数
    sysctl -p $flexgw_sysctl_file
fi
######################################

echo_info 安装依赖的软件包
yum install -y strongswan openvpn zip curl wget

echo_info 安装flexgw
rpm -ivh flexgw-1.1.0-1.el6.x86_64.rpm

echo_info 初始化配置
\cp -fv /usr/local/flexgw/rc/strongswan.conf /etc/strongswan/strongswan.conf
\cp -fv /usr/local/flexgw/rc/openvpn.conf /etc/openvpn/server.conf

echo_info 设置StrongSwan
dhcp_conf="/etc/strongswan/strongswan.d/charon/dhcp.conf"
string="load = yes"
if [ -f $dhcp_conf ]; then
  while read -r line; do
    if [[ $line =~ ^[[:blank:]]*$string ]]; then
      sed -i "s/$line/# $line/g" $dhcp_conf
    fi
  done < $dhcp_conf
fi
:>/etc/strongswan/ipsec.secrets
