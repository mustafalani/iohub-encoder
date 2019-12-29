#!/bin/bash
#Pair Encoder
#BASE-URL=($1)
#Key=($2)
#Value=($3)
CONTENT="\t\t<KeyValuePair>\n\t\t\t<BASE-URL>$1</BASE-URL>\n\t\t\t<Key>$2</Key>\n\t\t\t<Value>$3</Value>\n\t\t</KeyValuePair>";
C=$(echo $CONTENT | sed 's/\//\\\//g');
sed -i '/<\/KeyValuePairs>/i\'"$CONTENT" $HOME/iohub/config/config.xml && awk -F'[<>]' '/<deviceID>/ { print $3 }' $HOME/iohub/config/config.xml
