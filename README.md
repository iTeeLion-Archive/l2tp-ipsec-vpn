# L2TP/IPSEC PSK VPN install, configure and control script
Once I asked myself: dude, how to install and configure a VPN server? That night I will never forget. Long and tedious reading of the documentation and tons of Google requests, yeah that's was hard! Then I decided to make an automatic script for installing configuration and management for myself and you.

## Requirements
I tested this script on Debian 10/11, but it's may be adapted for many linux distros.
#### Default packages: (Debian 10/11)
Package name | Why needed
------------ | -------------
apt | To install packages
mc | To edit config files
wget | To download preconfigured config files
#### Another packages and distros
You may specify using packages like that:
```
#!/bin/bash
E="nano"
PM="yum"
```
For example: change `mcedit` to `nano` or `vim` or change `apt` to `yum` for use on CentOS

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

<details>
<summary>На русском</summary>
  
# Скрипт установки и управления L2TP/IPSEC PSK VPN сервером
Однажды я задолбался конфигурировать VPN серверы вручную и решил сделать скрипт для автоматического разворачивания всего необходимого в минимальном виде

## Требования
Я проверял скрипт только под Debian 10/11, но думаю это без труда заработает и в других дистрибутивах.

#### Another packages and distros
В скрипте можно настроить используемые пакеты
```
#!/bin/bash
E="nano"
PM="yum"
```
Напрмер: вместо `mcedit` можно использовать `nano` и т.д.

## Как использовать?
Просто скачать файл скрипта
```
wget https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/vpn.sh
```
или через curl
```
curl https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/vpn.sh --output vpn.sh
```

## Как установить и сконфигурировать VPN L2TP IPSEC PSK сервер
Установить:
```
./vpn.sh server install
```
Удалить:
```
./vpn.sh server remove
```

## Конфигурирование VPN ервера
Скачать настроенные мной конфиги 
```
./vpn.sh install-config all
```
Можно получить список доступных конфигов и поставить только нужные
```
./vpn.sh install-config
./vpn.sh install-config %configname%
```

## Управление
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
</details>
