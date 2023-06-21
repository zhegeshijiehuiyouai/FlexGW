#!/bin/bash

flexgw stop
strongswan stop
systemctl stop openvpn@server
cd ~
rpm -qa | grep flexgw | xargs rpm -e
yum remove -y openvpn strongswan
rm -rf /usr/local/flexgw
rm -rf /etc/openvpn
rm -rf /etc/strongswan
