#!/bin/sh

# Generate commands to configure a new Raspberry Pi FreeBSD installation.

HOSTNAME_DEFAULT="beastie"
DOMAIN_DEFAULT="home"
IP_ADDR_DEFAULT="192.168.1.100"
NETMASK_DEFAULT="255.255.255.0"
GATEWAY_DEFAULT="192.168.1.1"
DNS1_DEFAULT="208.67.222.222"
DNS2_DEFAULT="208.67.220.220"

echo "Enter the following parameters or press Enter to accept the default."
echo -n "Hostname [$HOSTNAME_DEFAULT]: "
read HOSTNAME
HOSTNAME="${HOSTNAME:-$HOSTNAME_DEFAULT}"
echo -n "Domain [$DOMAIN_DEFAULT]: "
read DOMAIN
DOMAIN="${DOMAIN:-$DOMAIN_DEFAULT}"
echo -n "Device IP address [$IP_ADDR_DEFAULT]: "
read IP_ADDR
IP_ADDR="${IP_ADDR:-$IP_ADDR_DEFAULT}"
echo -n "Subnet mask: [$NETMASK_DEFAULT]: "
read NETMASK
NETMASK="${NETMASK:-$NETMASK_DEFAULT}"
echo -n "Router address: [$GATEWAY_DEFAULT]: "
read GATEWAY
GATEWAY="${GATEWAY:-$GATEWAY_DEFAULT}"
echo -n "Primary DNS: [$DNS1_DEFAULT]: "
read DNS1
DNS1="${DNS1:-$DNS1_DEFAULT}"
echo -n "Secondary DNS: [$DNS2_DEFAULT]: "
read DNS2
DNS2="${DNS2:-$DNS2_DEFAULT}"
echo

cat <<EOF
Run these commands as root to configure your system:
sysrc hostname="$HOSTNAME.$DOMAIN"
sysrc ifconfig_ue0="$IP_ADDR netmask $NETMASK"
sysrc defaultrouter="$GATEWAY"
echo "search $DOMAIN" >/etc/resolv.conf
echo "nameserver $DNS1" >>/etc/resolv.conf
echo "nameserver $DNS2" >>/etc/resolv.conf
sysrc ntpd_enable="YES"
sysrc ntpd_sync_on_start="YES"
service ntpd start
tzsetup
EOF
