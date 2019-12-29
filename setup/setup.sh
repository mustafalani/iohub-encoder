#!/bin/bash
echo "Updating...";
yes | sudo apt update;
echo "Upgarding...";
yes | sudo apt upgrade;
#Installing Build Tools
echo "Installing Build Tools";
yes | sudo apt-get install xmlstarlet tclsh pkg-config cmake libssl-dev build-essential unzip avahi-daemon libavahi-client-dev flex bison xmlstarlet;
#Installing Dependences
echo "Installing Dependences";
yes  | sudo apt build-dep libavfilter-dev libavdevice-dev libavformat-dev libavutil-dev  libswresample-dev libavresample-dev libpostproc-dev libswscale-dev libavcodec-dev libavcodec-extra;
rm $HOME/iohub/logs/all/all
rm $HOME/iohub/logs/channels/channels
rm $HOME/iohub/logs/history/history
echo "$(tput setaf 6)Installing iohub®";
#download decklink drivers
cd $HOME/iohub/source
wget http://152.115.45.146/iohub/repo/Blackmagic_Desktop_Video_Linux_11.2.tar;
#SRT
cd $HOME/iohub/
echo "Installing Haivision SRT";
git clone https://github.com/Haivision/srt.git
cd srt
./configure
make
sudo make install
sudo cp -arf libsrt* /usr/lib/x86_64-linux-gnu/
sudo cp -arf /usr/local/lib/libsrt.* /usr/lib/x86_64-linux-gnu/
cd $HOME/iohub/
#NDI
echo "Installing Newtek NDI®";
cp source/InstallNDISDK_* $HOME/iohub/
chmod a+x InstallNDISDK_*
./InstallNDISDK_* >/dev/null < <(echo y) >/dev/null < <(echo y);
mv NDI\ SDK\ for\ Linux/ ndi
rm InstallNDISDK_*
cd ndi
sudo cp include/* /usr/include
sudo cp -arf lib/x86_64-linux-gnu/* /usr/lib/x86_64-linux-gnu/
cd $HOME/iohub/
#DeckLink SDK
cd $HOME/iohub/source/
wget http://152.115.45.146/iohub/repo/Blackmagic_DeckLink_SDK_11.2.zip
cd $HOME/iohub/
cp $HOME/iohub/source/Blackmagic_DeckLink_SDK_* $HOME/iohub/
unzip Blackmagic_DeckLink_SDK_*
mv Blackmagic\ DeckLink\ SDK* bm_sdk
rm Blackmagic_DeckLink_SDK_*
sudo cp bm_sdk/Linux/include/* /usr/local/include
cd $HOME/iohub/
#ffmpeg
echo "Installing ffmpeg";
#git clone https://git.ffmpeg.org/ffmpeg.git
wget http://152.115.45.146/iohub/repo/FFmpeg-4.1.zip;
unzip FFmpeg-4.1.zip
mv FFmpeg-4.1 ffmpeg
cd $HOME/iohub/ffmpeg/libavformat
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
cd $HOME/iohub/ffmpeg
yes | sudo apt-get install libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev libfdk-aac-dev libmp3lame-dev libopus-dev libsdl2-dev;
echo "Installing ffmpeg.. this will take some time sit back and relax";
echo -e "\xf0\x9f\x8d\xba"
./configure --enable-libndi_newtek --extra-cflags='-I$HOME/iohub/ndi/include -I$HOME/iohub/bm_sdk/Linux/include' --extra-ldflags=-L$HOME/iohub/ndi/lib/x86_64-linux-gnu --enable-libsrt --enable-ffplay --enable-decklink --enable-libx264 --enable-nonfree --enable-gpl --enable-libfdk-aac --enable-libopus --enable-libx265 --enable-openssl --enable-libfreetype --enable-libfontconfig --enable-libfribidi --enable-filter=drawtext
make;
sudo make install;
#Blackmagic driver
tar -C $HOME/iohub/ -xzf $HOME/iohub/source/Blackmagic_Desktop_Video_Linux*
mv $HOME/iohub/Blackmagic_Desktop_Video_Linux* $HOME/iohub/decklink
cd $HOME/iohub/decklink/deb/x86_64
sudo dpkg -i desktopvideo_*
yes | sudo apt-get install -f
sudo dpkg -i mediaexpress_*
yes | sudo apt-get install -f
cd $HOME/iohub/
#netdata
echo -ne '\n' | bash <(curl -Ss https://my-netdata.io/kickstart.sh)
#vtrunkd
cd $HOME/iohub/
git clone https://github.com/VrayoSystems/vtrunkd.git
cd vtrunkd
./configure --prefix=
make
sudo make install
#UpdateEncoderID
echo "$(tput setaf 7)Generating EnocderID...";
sleep 2
$HOME/iohub/scripts/UpdateEncoderID.sh;
#UpdateCrontab
cd $HOME/iohub/
crontab ./scripts/cron
echo "$(tput setaf 9)Done!"
