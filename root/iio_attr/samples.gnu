set term png size 1200 500
set output '/www/plot.png'
plot 'samples.bin' binary format='%short%short' using 1 with lines, 'samples.bin' binary format='%short%short' using 2 with lines

