#!/bin/sh

# Generate commands to configure network parameters.

HOSTNAME_DEFAULT="$(hostname -s)"
DOMAIN_DEFAULT="$(hostname -d)"
IP_ADDR_DEFAULT="$(ifconfig ue0 | grep inet | cut -w -f3)"
NETMASK_DEFAULT="$(ifconfig ue0 | grep netmask | cut -w -f5 | sed -e 's/0x//' -e 's/ff/255./g' -e 's/00/0/')"
GATEWAY_DEFAULT="$(route -n show default | grep gateway | cut -w -f3)"
DNS1_DEFAULT="$(grep nameserver /etc/resolv.conf | cut -w -f2 | sed -n 1p)"
DNS2_DEFAULT="$(grep nameserver /etc/resolv.conf | cut -w -f2 | sed -n 2p)"

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
echo "$IP_ADDR  $HOSTNAME.$DOMAIN  $HOSTNAME" >>/etc/hosts
sysrc hostname="$HOSTNAME.$DOMAIN"
sysrc ifconfig_ue0="$IP_ADDR netmask $NETMASK"
sysrc defaultrouter="$GATEWAY"
echo "search $DOMAIN" >/etc/resolv.conf
echo "nameserver $DNS1" >>/etc/resolv.conf
echo "nameserver $DNS2" >>/etc/resolv.conf

Reboot for changes to take effect.
EOF
