#
# LamaBleu 12/2019
# Usage : signal.sh Fstart Fend Step RXgain TXgain
#       : ./signal.sh 405000 460000 500 30 -40
#       (frequencies in kHz)
#      Do not use TXrun greater than -10dB  (stay between -89 to -10)!
#      To protect RX stage use RF attenuators !
#      Default TXgain is set -30 (if not specified)

cd /root/miniSNA
rm /root/miniSNA/test.csv 2>/dev/null
mv /root/.gnuplot /root/gnuplot.conf 2>/dev/null

fstart=$(($1*1000))
fend=$(($2*1000))
step=$(($3*1000))
rxgain=$4
txgain=${5:-30}
echo "FStart: $fstart -  Fend: $fend -  Steps: $step Hz"
echo "Pluto RXGAIN $rxgain, TXGAIN $txgain"
# TX : Pluto
/usr/bin/iio_attr -a -q -c -o ad9361-phy voltage0 hardwaregain $txgain 1>/dev/null
/usr/bin/iio_attr -a -q -c -o ad9361-phy voltage0 sampling_frequency 1600000 1>/dev/null
/usr/bin/iio_attr -a -q -D ad9361-phy bist_prbs 0 1>/dev/null
/usr/bin/iio_attr -a -q -D ad9361-phy bist_tone "1 1 0 0" 1>/dev/null

for freq in $(seq $((fstart)) $((step)) $((fend)))
 do

# Pluto by default.
# moRFeus : uncomment right section, comment pluto section.

# TX : Pluto BIST MODE
#
#
fbist=$(($freq-100000))
#fbist=$((freq))
/usr/bin/iio_attr -u local: -q -c ad9361-phy TX_LO frequency ${fbist} 1>/dev/null



# or TX : send freq to remote moRFeus via TCP
# (using https://github.com/LamaBleu/moRFeus_listener)
# adapt IP and uncomment
#
#exec 3<>/dev/tcp/192.168.40.13/7778 && echo "F ${freq}"  1>&3

# or TX :  using local moRFeus (need morfeus-tool from Othernet)
# download link : https://archive.othernet.is/morfeus_tool_v1.6/
# "sudo" workaround : https://archive.othernet.is/morfeus_tool_v1.6/morfeus.udev.rules
#
#./morfeus_tool setFrequency ${freq}
#sleep 0.3


# RX: get signal level
# -f 4 = sample rate. Increase up to 50 for a quicker sweep but less accurate.
pow_pluto -l ${freq} -g ${rxgain} -f 4 >> /root/miniSNA/test.csv
sleep 0.1
tail -n 1 /root/miniSNA/test.csv
done

# Pluto : stop bist mode
/usr/bin/iio_attr -u local: -D  9361-phy bist_tone "0 0 0 0" 2>/dev/null

# Plot

fstart=$(tail -1 /root/miniSNA/test.csv | awk '{print $1}')
fend=$(head -1 /root/miniSNA/test.csv | awk '{print $1}')
#echo $fstart $fend
/usr/bin/gnuplot -persist -e "fmax=$fstart;f0=$fend" /root/miniSNA/plot.gnu 2>/dev/null
echo "Full PNG plot  : http://pluto.local/plot.png or http://192.168.2.1/plot.png"
echo "               : saved to /www/plot.png"
mv /root/gnuplot.conf /root/.gnuplot 2>/dev/null
