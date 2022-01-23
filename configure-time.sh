#!/bin/sh

# Generate commands to configure system time.

if [ "$(id -u)" == "0" ]; then
  echo "You have to be root to do this and you, my friend, are not root."
else
  sysrc ntpd_enable="YES"
  sysrc ntpd_sync_on_start="YES"
  service ntpd start
  tzsetup
  date
fi
