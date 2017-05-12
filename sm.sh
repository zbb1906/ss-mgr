apt-get update
apt-get install -y build-essential npm wget curl tar unzip gettext build-essential screen autoconf automake libtool openssl libssl-dev zlib1g-dev xmlto asciidoc libpcre3-dev libudns-dev libev-dev vim
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
npm i -g shadowsocks-manager

ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:4000
mkdir ~/.ssmgr
vim ~/.ssmgr/ss.yml

```
type: s
empty: false
shadowsocks:
  address: 127.0.0.1:4000
manager:
  address: 0.0.0.0:4009
  password: '123456'
db: 'ss.sqlite'

```
ssmgr -c ss.yml
mkdir ~/.ssmgr
vim ~/.ssmgr/webgui.yml

```
type: m
empty: false

manager:
    address: 127.0.0.1:4009
    password: '123456'

plugins:
    flowSaver:
        use: true
    user:
        use: true
    account:
        use: true
        pay:
            hour:
                price: 0.03
                flow: 500000000
            day:
                price: 0.5
                flow: 7000000000
            week:
                price: 3
                flow: 50000000000
            month:
                price: 10
                flow: 200000000000
            season:
                price: 30
                flow: 200000000000
            year:
                price: 120
                flow: 200000000000
    email:
        use: true
        username: 'mmmwhy@126.com'
        password: 'lyyc12612345'
        host: 'smtp.126.com'
    webgui:
        use: true
        host: '0.0.0.0'
        port: '80'
        site: '127.0.0.1'
        gcmSenderId: '456102641793'
        gcmAPIKey: 'AAAAGzzdqrE:XXXXXXXXXXXXXX'
    alipay:
        use: true
        appid: 'adasd'
        notifyUrl: ''
        merchantPrivateKey: '<rsa_private_key.pem 中的私钥>'
        alipayPublicKey: '<支付宝公钥>'
        gatewayUrl: 'https://openapi.alipay.com/gateway.do'

db: 'webgui.sqlite'

```
ssmgr -c webgui.yml
