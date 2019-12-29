  GNU nano 2.9.3                                                                              setup.sh

#!/bin/bash
echo "$(tput setaf 2)iohub is now updating..! $(tput sgr 0)"
sleep 2;
cp -R $HOME/tmp/iohub/* $HOME/iohub/
echo "$(tput setaf 3)Adding System logs..$(tput sgr 0)";
mkdir $HOME/iohub/logs/all;
echo "$(tput setaf 3)Adding Channels logs..$(tput sgr 0)";
mkdir $HOME/iohub/logs/channels;
echo "$(tput setaf 3)Please wait..!$(tput sgr 0)";
sleep 2;
#UpdateEncoderID
$HOME/iohub/scripts/UpdateEncoderID.sh;
sleep 5;
echo "$(tput setaf 3)Please wait updating cronjobs..!$(tput sgr 0)"
crontab -l | cat; echo "* * * * * iohub/scripts/channel-status.sh >> iohub/logs/all/channel-status.log" | crontab -
echo "$(tput setaf 3)Please wait updating cronjobs..!$(tput sgr 0)";
crontab -l | cat; echo "* * * * * iohub/scripts/channel-uptime.sh >> iohub/logs/all/channel-uptime.log" | crontab -
echo "$(tput setaf 3)Please wait updating cronjobs..!$(tput sgr 0)";
crontab -l | cat; echo "* * * * * iohub/scripts/encoder-uptime.sh >> iohub/logs/all/encoder-uptime.log" | crontab -
sudo apt install xmlstarlet;
echo "$(tput setaf 2)DONE!"
