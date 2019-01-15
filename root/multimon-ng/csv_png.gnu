set terminal png size 2600,500
#set terminal png size 1920,500
#set terminal png size 800,150
set datafile separator ","
set xlabel "Time (ms)"
set ylabel "Arbitrary Power (dB?)"
set grid
#show mxtics
set xtics 0.5 rotate
set mxtics 10
set key off
set pointsize 0.5

name=plot_data_file

set title name." multimon-ng dump"
# name=system("echo $plot_data_file")

set output "/www/plot.png"

plot name.".csv" using 1:2 with linespoints pt 6  lc 3

