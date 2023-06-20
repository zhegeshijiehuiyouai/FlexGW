ChangeLog
=========

Version 1.2.0
-------------

适配CentOS7

* 升级StrongSwan 版本
* 升级OpenVPN 版本
* StrongSwan 可配置项增加
* StrongSwan 超长子网显示优化

Version 1.1.1
-------------

完善稳定性、细节。

* IPSec VPN：支持可选的IKEv2/ESP 加密算法、签名算法、DH 组。
* RPM 打包，不再依赖于pyenv。
* 完善Website log 日志，捕获异常消息。

Version 1.1.0
-------------

更新拨号VPN 配置。

* 拨号VPN：查看、修改账号时，密码默认隐藏，支持手工显示。
* 拨号VPN：可配置支持客户端间相互通信、单账号同时多个客户端在线。
* 拨号VPN：可配置通信协议为"UDP"或"TCP"。
* 更新文档描述，增加Classic 网络环境应用场景事例。

Version 1.0.0
-------------

First public release.

* 首次发布，支持IPSec VPN、拨号VPN、SNAT 功能。
