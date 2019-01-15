#!/bin/sh
# the default directory the script runs in is /dev, so change to the drive
# reference : https://archive.fosdem.org/2018/schedule/event/plutosdr/attachments/slides/2503/export/events/attachments/plutosdr/slides/2503/pluto_stupid_tricks.pdf
# pages 29 to 31
cd /tmp
# create a file
touch foobar.txt
echo default-on > /sys/class/leds/led0:green/trigger >> foobar.txt
# Set the LO up
/usr/bin/iio_attr -a -c ad9361-phy TX_LO frequency 435000000 >> foobar.txt
# Set the Sample frequency up, tone will appear at sampling_frequency/32
/usr/bin/iio_attr -a -c -o ad9361-phy voltage0 sampling_frequency 32000000 >> foobar.txt
# Turn the attenuation down
/usr/bin/iio_attr -a -c -o ad9361-phy voltage0 hardwaregain 0 >> foobar.txt
# https://wiki.analog.com/resources/tools-software/linux-drivers/iio-transceiver/ad9361#bist_tone
# Inject 0dBFS tone at Fsample/32 into TX (all channels enabled)
/usr/bin/iio_attr -a -D ad9361-phy bist_tone "1 0 0 0" >> foobar.txt
sleep 30
/usr/bin/iio_attr -a -c -o ad9361-phy voltage0 hardwaregain -89 >> foobar.txt
sleep 2
/usr/bin/iio_attr -a -c -o ad9361-phy voltage0 hardwaregain 0 >> foobar.txt
sleep 5
/usr/bin/iio_attr -a -c -o ad9361-phy voltage0 hardwaregain -89 >> foobar.txt
cp /tmp/foobar.txt /media/sda1/result.txt
cd /root
ACTION=remove_all /lib/mdev/automounter.sh



