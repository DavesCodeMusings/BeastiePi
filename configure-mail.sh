#!/bin/sh

# Enable mail delivery.

echo "Enabling Sendmail."
if [ $(sysrc sendmail_enable | grep -c YES) -ne 1 ]; then
  sysrc sendmail_enable="YES"
fi

echo "Enabling message submission queue."
if [ $(sysrc sendmail_msp_queue_enable | grep -c YES) -ne 1 ]; then
  sysrc sendmail_msp_queue_enable="YES"
fi

echo "Starting Sendmail service."
if [ "$(pgrep sendmail)" == "" ]; then
  service sendmail start
fi

echo "Checking for root alias. "
grep ^root /etc/aliases
if [ $? == 1 ]; then
  echo "Creating alias for root: freebsd"
  sed -i~ '/^# root:.*/a\
root: freebsd\
' /etc/mail/aliases
  newaliases
fi
