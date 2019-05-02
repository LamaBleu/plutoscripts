#
# Quick plot level/vs freq
# LamaBleu 06/2018
#
# CSV input file format (space separator) : 
# freq(Hz) level
# comments at the end of file only
#
#
#
#
set term qt 0  size 1000,400 position 30,30
set title "Fstart : " . sprintf("%09.3f", f0/1000) . " kHz  -  Fstop " . sprintf("%09.3f", fmax/1000) . " kHz"
set xlabel "freq. [MHz]"
#set yrange [90:0]
set ylabel "level [dB]"
set format x "%1.3f"
set timestamp
set key at graph 0.95, 0.95
set size 0.95,0.95
plot './test.csv' using ($1)/1000000:($2) with lines lc rgb '#bf000a' title 'pow.c calculation', \
'./test.csv' using ($1)/1000000:($2) s b lc rgb '#2e4053' title 'average'
set term qt 1
plot './test.csv' using ($1)/1000000:($3)*-1 with lines lc rgb '#2e4053' title 'RSSI (IIO data)'
#set term qt 2
#plot './test.csv' using ($1)/1000000:($3)*-1 with lines lc rgb '#444053' title 'Inverted RSSI'
#set terminal push
#set terminal png size 1200, 600
#set output './datas/signal.png'
#replot
#set terminal pop
#replot

