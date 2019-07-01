

set term png size 1300 600
set datafile separator ","
set output "/www/plot.png"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M:%S% \n %d/%m "
set title "id : " . sprintf("%d", id)
set autoscale 
set timestamp
set grid

set y2range [40:100]
set y2tics border tc lt 2
set y2label 'Humidity' tc rgb "#009e73"
set ylabel 'Temp degC' tc rgb "#bf000a"
set ytics nomirror tc rgb "#bf000a"
set y2tics nomirror

plot './rtl_433.csv' using 1:3 lc rgb '#bf000a' title 'temperature_C id : ' . sprintf("%d", id), \
'./rtl_433.csv' using 1:3 s b lc rgb '#2e4053' title 'average (degC)', \
'./rtl_433.csv' using 1:4 s b lc rgb '#00CC00' axes x1y2 title 'humidity (%)'


