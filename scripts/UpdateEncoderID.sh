#!/bin/bash
#UpdtaeEncoderID
encoderID=$(openssl rand -hex 12);
CONTENT="\t\<deviceID>$encoderID</deviceID>";
C=$(echo $CONTENT | sed 's/\//\\\//g');
sed -i '/<\KeyValuePairs>/i\'"$CONTENT" $HOME/iohub/config/config.xml && awk -F'[<>]' '/<deviceID>/ { print "EnocderID:   "$3 }' $HOME/iohub/config/config.xml
