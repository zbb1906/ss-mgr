#!/bin/bash
#Check Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }
#check OS version
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}
install_soft_for_each(){
	check_sys
	if [[ ${release} = "centos" ]]; then
		yum groupinstall "Development Tools" -y
		yum install -y wget curl tar unzip -y
		yum install -y gcc gettext-devel unzip npm autoconf automake make zlib-devel libtool xmlto asciidoc udns-devel libev-devel vim
		yum install -y pcre pcre-devel perl perl-devel cpio expat-devel openssl-devel mbedtls-devel screen nano
		curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
		apt-get install -y nodejs
	else
		apt-get update
		apt-get remove -y apache*
		apt-get install -y build-essential npm wget curl tar git unzip gettext build-essential screen autoconf automake libtool openssl libssl-dev zlib1g-dev xmlto asciidoc libpcre3-dev libudns-dev libev-dev vim
		curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
		apt-get install -y nodejs
	fi
}
install_soft_for_each
#libsodium
wget -N -P  /root https://raw.githubusercontent.com/mmmwhy/ss-panel-and-ss-py-mu/master/libsodium-1.0.11.tar.gz
tar xvf libsodium-1.0.11.tar.gz && rm -rf libsodium-1.0.11.tar.gz
pushd libsodium-1.0.11
./configure --prefix=/usr && make
make install
popd
wget https://tls.mbed.org/download/mbedtls-2.4.0-gpl.tgz
tar xvf mbedtls-2.4.0-gpl.tgz && rm -rf mbedtls-2.4.0-gpl.tgz
pushd mbedtls-2.4.0
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
popd
ldconfig
#ss-liber
wget -N -P  /root https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.0.3/shadowsocks-libev-3.0.3.tar.gz
tar -xf shadowsocks-libev-3.0.3.tar.gz && rm -rf shadowsocks-libev-3.0.3.tar.gz && cd shadowsocks-libev-3.0.3
./configure
make && make install
# ss-mgr
git clone https://github.com/mmmwhy/shadowsocks-manager.git "/root/shadowsocks-manager"
cd /root/shadowsocks-manager
npm i
# get_your_ip
IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
# node server.js
screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:4000
mkdir /root/.ssmgr
wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/mmmwhy/ss-mgr/master/ss.yml
sed -i "s#127.0.0.1#${IPAddress}#g" /root/.ssmgr/ss.yml
cd /root/shadowsocks-manager/
screen -dmS ss node server.js -c /root/.ssmgr/ss.yml
wget -N -P  /root/.ssmgr/ https://raw.githubusercontent.com/mmmwhy/ss-mgr/master/webgui.yml
sed -i "s#127.0.0.1#${IPAddress}#g" /root/.ssmgr/webgui.yml
screen -dmS webgui node server.js -c /root/.ssmgr/webgui.yml