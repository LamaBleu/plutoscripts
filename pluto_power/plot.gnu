# Quick plot level/vs freq - Pluto miniSNA
# LamaBleu 12/2019
#
# CSV input file format (space separator) : 
# freq(Hz) level
# comments at the end of file only
#
#
#
#
set terminal png size 1200 400
set output '/www/plot.png'
set title "Fstart : " . sprintf("%09.3f", f0/1000) . " kHz  -  Fstop " . sprintf("%09.3f", fmax/1000) . " kHz"
set xlabel "freq. [MHz]"
#set yrange [90:0]
set ylabel "level [dB]"
set format x "%1.3f"
set xrange [f0/1000000:fmax/1000000]
set timestamp
set key at graph 0.95, 0.95
#set size 0.95,0.95
plot '/root/miniSNA/test.csv' using ($1)/1000000:($2) with lines lc rgb '#bf000a' title 'pow.c calculation', \
'/root/miniSNA/test.csv' using ($1)/1000000:($2) s b lc rgb '#2e4053' title 'average'
set term dumb
plot './root/miniSNA/test.csv'
#set term qt 1
# RSSI (sent by IIO)
#plot '/root/miniSNA/test.csv' using ($1)/1000000:($3)*-1 with lines lc rgb '#2e4053' title 'RSSI (IIO data)'
#set term qt 2
#plot '/root/miniSNA/test.csv' using ($1)/1000000:($3)*-1 with lines lc rgb '#444053' title 'Inverted RSSI'
# 
