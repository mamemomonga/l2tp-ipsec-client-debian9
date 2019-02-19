#!/bin/bash
set -eu
source config

set -x
# L2TP停止
systemctl stop xl2tpd
sleep 1

# IPsec停止
systemctl stop strongswan
sleep 1

# IPsec起動
systemctl start strongswan
sleep 1

# IPsec状態
ipsec status
sleep 1

# L2TP開始
systemctl start xl2tpd
sleep 1

