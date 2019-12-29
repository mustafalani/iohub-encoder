#!/bin/bash
#update apt list
echo "Upateing system";
sleep 2;
sudo apt update;
sudo apt upgrade;
echo "Installing Haivision SRT";
sleep 2;
git clone https://github.com/Haivision/srt.git;
cd srt;
./configure;
make;
sudo make install;
echo "Installing Haivision SRT";
sleep 5;
sudo cp -arf libsrt* /usr/lib/x86_64-linux-gnu/;
sudo cp -arf /usr/local/lib/libsrt.* /usr/lib/x86_64-linux-gnu/;
cd ..
echo "Installing Newtek NDI®";
sleep 2;
cp ./source/InstallNDISDK_v3* ./;
chmod a+x InstallNDISDK_v3*;
mv InstallNDISDK_v3* InstallNDISDK_v3_Linux.sh;
./InstallNDISDK_v3_Linux.sh;
mv NDI\ SDK\ for\ Linux/ ndi;
cd ndi;
echo "Installing Newtek NDI®";
sleep 5;
sudo cp include/* /usr/include;
sudo cp -arf lib/x86_64-linux-gnu/* /usr/lib/x86_64-linux-gnu/;
cd ..
rm InstallNDISDK_v3_Linux.sh;
echo "installing Desktop Video SDK"
sleep 2;
cp ./source/Blackmagic_DeckLink_SDK_* ./;
unzip Blackmagic_DeckLink_SDK_*;
mv Blackmagic\ DeckLink\ SDK* bm_sdk;
rm Blackmagic_DeckLink_SDK_*;
echo "installing Desktop Video SDK"
sleep 5;
sudo cp bm_sdk/Linux/include/* /usr/local/include;
echo "Installing ffmpeg"
sleep 2;
git clone https://git.ffmpeg.org/ffmpeg.git;
cd ffmpeg/libavformat;
cat > srt_patch.patch << EOT
diff --git a/libavformat/libsrt.c b/libavformat/libsrt.c
index 0f9529d..073261b 100644
--- a/libavformat/libsrt.c
+++ b/libavformat/libsrt.c
@@ -466,6 +466,7 @@ static int libsrt_open(URLContext *h, const char *uri, int flags)
             }
         }
     }
+    h->max_packet_size = 1316;
     return libsrt_setup(h, uri, flags);
 }
EOT
patch < srt_patch.patch;
cd ..
./configure --enable-libndi_newtek --extra-cflags='-I$HOME/iohub/ndi/include -I$HOME/iohub/bm_sdk/Linux/include' --extra-ldflags=-L$HOME/iohub/ndi/lib/x86_64-linux-gnu --enable-libsrt --enable-ffplay --enable-decklink --enable-libx264 --enable-nonfree --enable-gpl --enable-libfdk-aac --enable-libopus --enable-libx265 --enable-openssl
make;
sudo make install;
cd ..
echo "installing DeckLink Drivers"
sleep 2;
tar -xzf ./source/Blackmagic_Desktop_Video_Linux_*;
mv Blackmagic_Desktop_Video_Linux_* decklink;
sudo dpkg -i ./decklink/deb/x86_64/*.deb;
echo "Upgraded DeckLink firmware"
sleep 2;
BlackmagicFirmwareUpdater update 0;
BlackmagicFirmwareUpdater update 1;
BlackmagicFirmwareUpdater update 2;
BlackmagicFirmwareUpdater update 3;
echo "$(tput setaf 2)DONE!"
