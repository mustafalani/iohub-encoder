#channel-uptime
xmlstarlet sel -t -m '//KeyValuePair' -v 'concat(BASE-URL," ", Key, " ", Value, " ")' -nl $HOME/iohub/config/config.xml | while read base_url key value
do
base_url=$base_url;
for file in $HOME/iohub/logs/channels/*; do
if ps aux | grep "$(basename "$file")" | grep -v "grep";
then
channelID="$(basename "$file")";
loopid=$(ps -ef | grep "$(basename "$file")" | grep -v "grep" | grep -h "while" | grep "ffmpeg" | awk '{print $2}');
uptime=$(ps -p "$loopid" -o lstart=);
curl -k -H 'Content-Type:application/json' -X POST -d '{"channelId":"'"$(basename "$file")"'","uptime":"'"$uptime"'"}' $base_url/channels/update_uptime;
else curl -k -H 'Content-Type:application/json' -X POST -d '{"channelId":"'"$(basename "$file")"'","uptime":"00:00:00"}' $base_url/channels/update_uptime;
fi
done;
done
