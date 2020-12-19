# L2TP/IPSEC PSK VPN install, configure and control script
Once I asked myself: dude, how to install and configure a VPN server? That night I will never forget. Long and tedious reading of the documentation and tons of Google requests, yeah that's was hard! Then I decided to make an automatic script for installing configuration and management for myself and you.

## How to use
Just download vpn.sh file:
```
wget https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/vpn.sh
```
or
```
curl https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/vpn.sh --output vpn.sh
```

## How to install/remove vpn server
To install:
```
./vpn.sh server install
```
To remove:
```
./vpn.sh server remove
```

## How to config
To download preconfigured config files:
```
./vpn.sh install-config all
```
or get list of available configs and install only needed
```
./vpn.sh install-config
./vpn.sh install-config %configname%
```

## How to control
Start:
```
./vpn.sh control start
```
Restart:
```
./vpn.sh control restart
```
Stop:
```
./vpn.sh control stop
```
