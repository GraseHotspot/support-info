#!/bin/bash

version=2020061401

echo "This script will collect information about your system that is useful for debugging the Grase Hotspot system. You will be required to copy and paste the output into an email that you send to the support list."
echo "Some of the information gather may be sensative depending on your environment. It may contain private network IP's, MAC addresses etc. Please review the data before sending it"
echo -n "Do you wish to continue?"
read answer
echo

TMPFILE=$(mktemp)
user=$(whoami)
host=$(hostname -f)

(
echo "Grase Support Information Script = $version"
echo "== Grase Package versions =="
apt-cache policy 'grase-*' 'coova-chilli' 'freeradius' 'squid3' 'mysql-server' 'mariadb-server'
echo "== Grase Repository Details =="
cat /etc/apt/sources.list.d/grasehotspot.list
echo "== Grase DNS Details =="
cat /etc/dnsmasq.d/01-grasehotspot
echo "== Chilli Radius local.conf (without macpasswd) =="
cat /etc/chilli/local.conf |grep -v macpasswd
echo "== Squid extra grase.d config =="
ls -l /etc/squid3/grase.d/*
cat /etc/squid3/grase.d/*
echo "== Linux Distro and version =="
lsb_release -a
echo "== Network Information =="
echo "= Ifconfig ="
/sbin/ifconfig -a
echo "= /etc/network/interfaces ="
cat /etc/network/interfaces
echo "= Network Manager ="
nmcli -p connection show --active
echo "== Network Manager settings =="
cat /etc/NetworkManager/NetworkManager.conf
ls -l /etc/dnsmasq.d/network-manager
cat /etc/dnsmasq.d/network-manager
echo "= Hard disk information ="
df -h

echo "= Status of services ="
echo "== CoovaChilli =="
systemctl status chilli || /usr/sbin/service chilli status
systemctl status freeradius || /usr/sbin/service freeradius status
systemctl status apache2 || /usr/sbin/service apache2 status
systemctl status squid3 || /usr/sbin/service squid3 status
systemctl status mysql || /usr/sbin/service mysql status
systemctl status network-manager || /usr/sbin/service network-manager status
echo "= User information ="
echo "$user@$host"

echo "
==============================================================================="
) | tee -a $TMPFILE

echo "Please send the above information to the mailing list along with your support request"
echo "You can find it all stored in $TMPFILE for ease of sending it"
