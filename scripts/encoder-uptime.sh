#!/bin/bash
#Encoder Uptime
encuptime=$(uptime -p);
xmlstarlet sel -t -m '//KeyValuePair' -v 'concat(BASE-URL," ", Key, " ", Value, " ")' -nl $HOME/iohub/config/config.xml | while read base_url key value
do
base_url=$base_url;
key=$key;
value=$value;
curl -k -H  'Content-Type: application/json'  --data '{"uptime":"'"$encuptime"'","encoderId":"'"${value}"'"}' $base_url/encoders/update_uptime;
done
