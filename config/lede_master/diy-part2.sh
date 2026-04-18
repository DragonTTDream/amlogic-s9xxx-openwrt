#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# ==========================================
# 1. 基础系统设定 (主机名与密码)
# ==========================================

# 1.1 修改主机名为 Phicomm-N1
sed -i 's/OpenWrt/Phicomm-N1/g' package/base-files/files/bin/config_generate

# 1.2 修改默认登录密码为 'password'
# 对应密文: $1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# ==========================================
# 2. 网络初始化设定 (针对旁路由模式)
# ==========================================

# 2.1 修改默认局域网 IP (N1的访问地址) 为 192.168.1.3
sed -i 's/192.168.1.1/192.168.1.3/g' package/base-files/files/bin/config_generate

# 2.2 强制设定 LAN 接口的默认网关指向主路由 192.168.1.1
sed -i '/set network.$1.netmask='\''$netm'\''/a \t\t\t\tset network.$1.gateway='\''192.168.1.1'\''' package/base-files/files/bin/config_generate

# 2.3 强制设定 LAN 接口的默认 DNS 指向主路由 192.168.1.1
sed -i '/set network.$1.gateway='\''192.168.1.1'\''/a \t\t\t\tset network.$1.dns='\''192.168.1.1'\''' package/base-files/files/bin/config_generate

# ==========================================
# 3. IPv6 管理
# ==========================================

# 3.1 剔除 LAN 接口的 IPv6 地址分配权限 (防止冲突)
sed -i '/set network.$1.ip6assign='\''60'\''/d' package/base-files/files/bin/config_generate

# ==========================================
# 4. 无线网络 (WiFi) 初始化设定
# ==========================================

# 4.1 默认开启 WiFi 功能
sed -i 's/disabled=1/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 4.2 设置 WiFi 名称 (SSID) 为 Phicomm-N1
sed -i 's/ssid=OpenWrt/ssid=Phicomm-N1/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 4.3 设置 WiFi 加密方式为 WPA2 (psk2)
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 4.4 设置 WiFi 密码为 password
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a \t\t\tset wireless.default_radio${devidx}.key='\''password'\''' package/kernel/mac80211/files/lib/wifi/mac80211.sh
