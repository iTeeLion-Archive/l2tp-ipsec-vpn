#!/bin/bash

E="mcedit"
PM="apt"
ipsec="strongswan"
l2tp="xl2tpd"

cf_ppp_secrets="/etc/ppp/chap-secrets"
cf_l2tp="/etc/xl2tpd/xl2tpd.conf"
cf_l2tp_options="/etc/ppp/options.xl2tpd"
cf_ipsec="/etc/ipsec.conf"
cf_ipsec_secrets="/etc/ipsec.secrets"
cf_sysctl="/etc/sysctl.conf"

cfurl_ppp_secrets="https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/configs/etc/ppp/chap-secrets"
cfurl_l2tp="https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/configs/etc/xl2tpd/xl2tpd.conf"
cfurl_l2tp_options="https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/configs/etc/ppp/options.xl2tpd"
cfurl_ipsec="https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/configs/etc/ipsec.conf"
cfurl_ipsec_secrets="https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/configs/etc/ipsec.secrets"
cfurl_sysctl="https://raw.githubusercontent.com/iTeeLion/l2tp-ipsec-vpn/master/configs/etc/sysctl.conf"

msg_cmd_control="$0 control start|stop|restart|status"
msg_cmd_editconfig="$0 edit-config secrets|l2tp|l2tp-options|ipsec|ipsec-secrets|sysctl"
msg_cmd_installconfigs="$0 install-config all|secrets|l2tp|l2tp-options|ipsec|ipsec-secrets"
msg_cmd_server="$0 server install|reinstall|remove|purge"

function showAreYouShure() {
    read -p "Are you sure? [y/n] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
	exit 1
    fi
}

function doControl(){
    case $1 in
        start)
	    echo "Trying to start $ipsec & $l2tp"
	    eval "systemctl start $ipsec"
	    eval "systemctl start $l2tp"
	;;
	stop)
	    echo "Trying to stop $ipsec & $l2tp"
	    eval "systemctl stop $ipsec"
	    eval "systemctl stop $l2tp"
	;;
	restart)
	    echo "Trying to restart $ipsec & $l2tp"
	    eval "systemctl restart $ipsec"
	    eval "systemctl restart $l2tp"
	;;
	status)
	    echo "Services status:"
	    eval "systemctl status $ipsec"
	    eval "systemctl status $l2tp"
	;;
	*)
	    echo "Usage: $msg_cmd_control"
	;;
    esac
}

function setupFirewall(){
    echo "Allow nat and masquerading in firewall"
    iptables --table nat --append POSTROUTING --jump MASQUERADE
}

function allowIpForward(){
    echo "Allow ip forwarding"
    echo 1 > /proc/sys/net/ipv4/ip_forward
    for each in /proc/sys/net/ipv4/conf/* 
    do
	echo 0 > $each/accept_redirects
	echo 0 > $each/send_redirects
    done
}

function doSetupNetwork() {
    # ToDo
    # uncomment row "net.ipv4.ip_forward = 1" in /etc/sysctl.conf
    setupFirewall
    allowIpForward
}

function doEditConfig(){
    case $1 in
	secrets)
	    eval "$E $cf_ppp_secrets"
	;;
	l2tp)
	    eval "$E $cf_l2tp"
	;;
	l2tp-options)
	    eval "$E $cf_l2tp_options"
	;;
	ipsec)
	    eval "$E $cf_ipsec"
	;;
	ipsec-secrets)
	    eval "$E $cf_ipsec_secrets"
	;;
	sysctl)
	    eval "$E $cf_sysctl"
	;;
	*)
	    echo "Usage: $msg_cmd_editconfig"
	;;
    esac
}

function doInstallConfigAll(){
    doInstallConfig secrets
    doInstallConfig l2tp
    doInstallConfig l2tp-options
    doInstallConfig ipsec
    doInstallConfig ipsec-secrets
}

function sayInstallConfig(){
    echo "Install preconfigured file: $1"
}

function doInstallConfig(){
    echo "Install wget if not installed"
    apt install -y wget
    case $1 in
	all)
	    doInstallConfigAll
	;;
	secrets)
	    sayInstallConfig $cf_ppp_secrets
	    wget -O "$cf_ppp_secrets" "$cfurl_ppp_secrets"
	;;
	l2tp)
	    sayInstallConfig $cf_l2tp
	    wget -O "$cf_l2tp" "$cfurl_l2tp"
	;;
	l2tp-options)
	    sayInstallConfig $cf_l2tp_options
	    wget -O "$cf_l2tp_options" "$cfurl_l2tp_options"
	;;
	ipsec)
	    sayInstallConfig $cf_ipsec
	    wget -O "$cf_ipsec" "$cfurl_ipsec"
	;;
	ipsec-secrets)
	    sayInstallConfig $cf_ipsec_secrets
	    wget -O "$cf_ipsec_secrets" "$cfurl_ipsec_secrets"
	;;
	*)
	    echo " "
	    echo "---------------------------------------------------------------------"
	    echo "| WARNING!!! This action replace all data in choosen config file!!! |"
	    echo "---------------------------------------------------------------------"
	    echo " "
	    echo "Usage: $msg_cmd_installconfigs"
	;;
    esac
}

function askInstallConfigs(){
    while true; do
	read -p "Do you want to install preconfigured config files? [y/n] " yn
	case $yn in
	    [Yy]* ) 
		doInstallConfigAll 
		break
	    ;;
	    [Nn]* ) 
		exit
	    ;;
	    * ) 
		echo "Please answer y - yes or n - no"
	    ;;
	esac
    done
}

function doServer(){
    case $1 in
	install)
	    eval "$PM install -y $ipsec $l2tp"
	    askInstallConfigs
	;;
	reinstall)
	    eval "$PM reinstall -y $ipsec $l2tp"
	    askInstallConfigs
	;;
	remove)
	    showAreYouShure
	    eval "$PM remove -y $ipsec $l2tp"
	;;
	purge)
	    showAreYouShure
	    eval "$PM purge -y $ipsec $l2tp"
	;;
	*)
	    echo "Usage: $msg_cmd_server"
	;;
    esac
}

function showHelp(){
    echo "Usage:" 
    echo " "
    echo "- control your vpn server"
    echo "	$msg_cmd_control" 
    echo " "
    echo "- edit config files"
    echo "	$msg_cmd_editconfig" 
    echo " "
    echo "- install preconfigured config files (by iTeeLion)"
    echo "	$msg_cmd_installconfigs" 
    echo " "
    echo "- setup network (allow nat and masquerading in firewall and allow ip forwarding)"
    echo "	$0 setup-network" 
    echo " "
    echo "- install/remove server (Packages: $ipsec & $l2tp)"
    echo "	$msg_cmd_server" 
    echo " "
}

case $1 in
    control)
	doControl $2
    ;;
    setup-network)
	doSetupNetwork
    ;;
    edit-config)
	doEditConfig $2
    ;;
    install-configs)
	doInstallConfig $2
    ;;
    server)
	doServer $2
    ;;
    help)
	showHelp
    ;;
    *)
	showHelp
    ;;
esac
