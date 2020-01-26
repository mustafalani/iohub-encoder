#!/bin/bash
phost='152.115.45.143'
vhost='10.147.18.1'
vport='5001'
vprofile='000003_2'
fping -c1 -t300 $vhost 2>/dev/null 1>/dev/null
if [ "$?" = 0 ]
then
  echo "$(date '+%A %W %Y %X')	All Good" >> /home/iohub/iohub/logs/all/vtrunkd.log
elif pgrep -x vtrunkd >/dev/null
then echo "$(date '+%A %W %Y %X')	Restarting vtrunkd" >> /home/iohub/iohub/logs/all/vtrunkd.log
pkill -9 vtrunkd
sleep 2
sudo vtrunkd -P $vport -f /etc/vtrunkd.conf $vprofile $phost
echo "$(date '+%A %W %Y %X')	vtrunkd has started" >> /home/iohub/iohub/logs/all/vtrunkd.log
sleep 2
fping -c1 -t300 $vhost 2>/dev/null 1>/dev/null
  if [ "$?" = 0 ]
  then
    echo "$(date '+%A %W %Y %X')	All Good Again" >> /home/iohub/iohub/logs/all/vtrunkd.log
  else
    echo "$(date '+%A %W %Y %X')	Something went wrong we will try again later.." >> /home/iohub/iohub/logs/all/vtrunkd.log
  fi
else
  echo "$(date '+%A %W %Y %X')	Starting vtrunkd" >> /home/iohub/iohub/logs/all/vtrunkd.log
  sudo vtrunkd -P $vport -f /etc/vtrunkd.conf $vprofile $phost
  sleep 2
  fping -c1 -t300 $vhost 2>/dev/null 1>/dev/null
  if [ "$?" = 0 ]
  then
    echo "$(date '+%A %W %Y %X')	All Good" >> /home/iohub/iohub/logs/all/vtrunkd.log
  else
    echo "$(date '+%A %W %Y %X')	Something went wrong we will try again later.." >> /home/iohub/iohub/logs/all/vtrunkd.log
  fi
fi
