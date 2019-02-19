#!/bin/bash
set -eu
source config

echo "Write: /etc/ipsec.conf"
sudo sh -c 'cat > /etc/ipsec.conf' << EOS
config setup
conn $IL_NAME
	keyexchange=ikev1
	authby=secret

	rekey=yes
	
	keyingtries=3
	type=transport
	auto=start
	
	ike=3des-sha1-modp1024
	esp=3des-sha1-modp1024
	
	leftfirewall=yes
	
	left=%defaultroute
	leftprotoport=17/1701
	
	right=$IL_RIGHT
	rightprotoport=17/1701
EOS

echo "Write: /etc/ipsec.secrets"
sudo sh -c 'cat > /etc/ipsec.secrets' << EOS
 : PSK "$IL_PSK"
EOS

echo "Write: /etc/xl2tpd/xl2tpd.conf"
sudo sh -c 'cat > /etc/xl2tpd/xl2tpd.conf' << EOS
[lac $IL_NAME]
lns = $IL_RIGHT
pppoptfile = /etc/ppp/options.l2tpd.client
length bit = yes
autodial = yes
redial = yes
redial timeout = 10
max redials = 6
EOS

echo "Write: /etc/ppp/options.l2tpd.client"
sudo sh -c 'cat > /etc/ppp/options.l2tpd.client' << EOS
name $IL_USER
password $IL_PASS
noauth
mtu 1410
mru 1410
defaultroute
persist
EOS

