# Quick CSV convert for rx_power (one pass)
#
# Usage : signal.sh Fstart(MHz) Fend(MHz) Step(Hz) [gain]
# signal.sh 1400 2600 25 70 <---   1400MHz to 2600MHz, 25 kHz step, gain 70 [0:73]
#
#       use rx_power with -1 option only (one pass)
#       adapt path!

iio_attr -q -c ad9361-phy voltage0 gain_control_mode slow_attack
cd /root
rm fm.*
fstart=$1
fstop=$2
fstep=$3

if [ "$4" = "" ]; then
    rxgain=70
else
    rxgain=$4
fi
echo "rxgain:" $rxgain


rx_power -d driver=plutosdr -c 0.3 -1 -g ${rxgain} -f ${fstart}M:${fstop}M:${fstep}k -F CF32 fm.csv

#head -6 fm.csv > fm.data
awk -F, '{getline f1 <"file2" ;print f1,$1,$2,$3,$4,$5}' IFS=, fm.csv > fm.dat
cut -f7- -d',' fm.csv > fm.tmp
tr , '\n' < fm.tmp > fm.plt



cp fm.plt fm.csv
echo "# Date Time Fstart Fend Step(Hz)" >> fm.csv
sed 's/^/#/' fm.dat >> fm.csv
gnuplot -e "fstart=$fstart;fstop=$fstop;fstep=$fstep"  rtl_power.gnu
echo "Full PNG plot  : http://pluto.local/plot.png or http://192.168.2.1/plot.png"
rm fm.plt fm.tmp fm.dat





