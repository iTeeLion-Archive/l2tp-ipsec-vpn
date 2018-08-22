#!/bin/bash

E="mcedit"
PM="apt"
ipsec="strongswan"
l2tp="xl2tpd"
cf_ppp_secrets="/etc/ppp/chap-secrets"
cf_l2tp="/etc/xl2tpd/xl2tpd.conf"
cf_l2tp_opt="/etc/ppp/options.xl2tpd"
cf_ipsec="/etc/ipsec.conf"
cf_ipsec_sec="/etc/ipsec.secrets"
cf_sysctl="/etc/sysctl.conf"

function setup(){
    echo "ToDo setup"
}

function control(){
    case $1 in
	start)
	    eval "systemctl start $ipsec"
	    eval "systemctl start $l2tp"
	    echo "Try to start $ipsec & $l2tp"
	;;
	stop)
	    eval "systemctl stop $ipsec"
	    eval "systemctl stop $l2tp"
	    echo "Try to stop $ipsec & $l2tp"
	;;
	restart)
	    eval "systemctl restart $ipsec"
	    eval "systemctl restart $l2tp"
	    echo "Try to restart $ipsec & $l2tp"
	;;
	*)
	    echo "Use: start|stop|restart"
	;;
    esac
}

function config(){
    case $1 in
	secrets)
	    eval "$E $cf_ppp_secrets"
	;;
	l2tp)
	    eval "$E $cf_l2tp"
	;;
	l2tp-opt)
	    eval "$E $cf_l2tp_opt"
	;;
	ipsec)
	    eval "$E $cf_ipsec"
	;;
	ipsec-sec)
	    eval "$E $cf_ipsec_sec"
	;;
	sysctl)
	    eval "$E $cf_sysctl"
	;;
	*)
	    echo "Use: secrets|l2tp|l2tp-opt|ipsec|ipsec-sec|sysctl"
	;;
    esac
}

case $1 in
    install)
	eval "$PM install -y $ipsec $l2tp"
    ;;
    reinstall)
	eval "$PM reinstall -y $ipsec $l2tp"
    ;;
    remove)
	eval "$PM remove $ipsec $l2tp"
    ;;
    setup)
	setup
    ;;
    config)
	config $2
    ;;
    control)
	control $2
    ;;
    *)
	echo "Use: install|setup|config|control"
    ;;
esac