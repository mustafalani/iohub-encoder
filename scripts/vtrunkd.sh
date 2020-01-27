#!/bin/bash
phost='152.115.45.143'
vhost='10.147.18.1'
vport='5001'
vprofile='000003_2'
echo "$(date '+%A %d-%m-%Y %X')	Examing connection" >> /home/iohub/iohub/logs/all/vtrunkd.log
fping -c1 -t300 $vhost >> /home/iohub/iohub/logs/all/vtrunkd.log
if [ "$?" = 0 ]
then
  echo "$(date '+%A %d-%m-%Y %X')	All Good" >> /home/iohub/iohub/logs/all/vtrunkd.log
elif pgrep -x vtrunkd >> /home/iohub/iohub/logs/all/vtrunkd.log
then echo "$(date '+%A %d-%m-%Y %X')	Restarting vtrunkd" >> /home/iohub/iohub/logs/all/vtrunkd.log
pkill -9 vtrunkd >> /home/iohub/iohub/logs/all/vtrunkd.log
sleep 5
sudo vtrunkd -P $vport -f /etc/vtrunkd.conf $vprofile $phost >> /home/iohub/iohub/logs/all/vtrunkd.log
sleep 3
echo "$(date '+%A %d-%m-%Y %X')	vtrunkd started..." >> /home/iohub/iohub/logs/all/vtrunkd.log
echo "$(date '+%A %d-%m-%Y %X')	Examing connection after restart" >> /home/iohub/iohub/logs/all/vtrunkd.log
fping -c1 -t300 $vhost >> /home/iohub/iohub/logs/all/vtrunkd.log
  if [ "$?" = 0 ]
  then
    echo "$(date '+%A %d-%m-%Y %X')	All Good Again" >> /home/iohub/iohub/logs/all/vtrunkd.log
  else
    echo "$(date '+%A %d-%m-%Y %X')	Something went wrong we will try again later..." >> /home/iohub/iohub/logs/all/vtrunkd.log
  fi
else
  echo "$(date '+%A %d-%m-%Y %X')	Starting vtrunkd" >> /home/iohub/iohub/logs/all/vtrunkd.log
  sudo vtrunkd -P $vport -f /etc/vtrunkd.conf $vprofile $phost >> /home/iohub/iohub/logs/all/vtrunkd.log
  sleep 3
  echo "$(date '+%A %d-%m-%Y %X')	vtrunkd started.." >> /home/iohub/iohub/logs/all/vtrunkd.log
  echo "$(date '+%A %d-%m-%Y %X')	Examing connection.." >> /home/iohub/iohub/logs/all/vtrunkd.log
  fping -c1 -t300 $vhost >> /home/iohub/iohub/logs/all/vtrunkd.log
  if [ "$?" = 0 ]
  then
    echo "$(date '+%A %d-%m-%Y %X')	All Good" >> /home/iohub/iohub/logs/all/vtrunkd.log
  else
    echo "$(date '+%A %d-%m-%Y %X')	Something went wrong we will try again later.." >> /home/iohub/iohub/logs/all/vtrunkd.log
  fi
fi
