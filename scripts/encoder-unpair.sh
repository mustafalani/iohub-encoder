#!/bin/bash
#UnPair Encoder
#BASE-URL=($1)
#Key=($2)
#Value=($3)
xmlstarlet sel -t -m '//KeyValuePair' -v 'concat(BASE-URL, " ", Key, " ", Value, " ")' -nl $HOME/iohub/config/config.xml | while read -r line;
do echo "this is $line";
done
#xmlstarlet ed -L -d "//KeyValuePair[Value/text()="$1"]" $HOME/iohub/config/config.xml
#xmlstarlet ed -L -d "//KeyValuePair[Value/text()=$1]" $HOME/iohub/config/config.xml
