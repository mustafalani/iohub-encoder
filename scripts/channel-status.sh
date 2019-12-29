#channel-status
xmlstarlet sel -t -m '//KeyValuePair' -v 'concat(BASE-URL," ", Key, " ", Value, " ")' -nl $HOME/iohub/config/config.xml | while read base_url key value
do
base_url=$base_url;
for file in $HOME/iohub/logs/channels/*; do
if ps aux | grep "$(basename "$file")" | grep "ffmpeg" | grep -v "grep";
then curl -k -H 'Content-Type:application/json' -X POST -d '{"channelId":"'"$(basename "$file")"'","status":"1"}' $base_url/channels/update;
else curl -k -H 'Content-Type:application/json' -X POST -d '{"channelId":"'"$(basename "$file")"'","status":"0"}' $base_url/channels/update;
fi
done;
done
