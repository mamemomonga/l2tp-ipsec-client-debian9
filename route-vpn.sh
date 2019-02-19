#!/bin/bash
set -eu
source config

# 本来のデフォルトゲートウェイ
DEFAULT_GW=$(ip route show | grep default | awk '{ print $3 }')

# 保存
sudo ip route save > ip-route-save

set -x

# ------------------------------------------
# 本来のデフォルトゲートウェイを使用する経路
# ------------------------------------------

# VPNのIPsec通信
sudo ip route add $IL_RIGHT via $DEFAULT_GW

# 現在ログイン中のSSH
sudo ip route add $( echo $SSH_CLIENT | awk '{ print $1 }' ) via $DEFAULT_GW

# プライベートネットワーク
sudo ip route add 10.0.0.0/8     via $DEFAULT_GW metric 5000
sudo ip route add 172.16.0.0/12  via $DEFAULT_GW metric 5000
sudo ip route add 192.168.0.0/16 via $DEFAULT_GW metric 5000

# GCE:メタデータはeth0へ
# GCEではDNSもメタデータサーバの方向を向いている
sudo ip route add 169.254.169.254 dev eth0

# ------------------------------------------
# VPN回線を使用する経路
# ------------------------------------------

# 特定のプライベートネットワーク
sudo ip route add $IL_PEER_NETWORK via $IL_PEER_GW metric 1000

# デフォルトゲートウェイ削除
sudo ip route del default

# デフォルトゲートウェイ
sudo ip route add default via $IL_PEER_GW

