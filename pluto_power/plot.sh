#!/bin/bash

# Will display a plot from example.csv file
# and save the plot as example-1.png
# CSVfile : freq(Hz) level(dB) 
#fstart=tail -1 ./test.csv | awk '{print $1}')

fstart=$(tail -1 ./test.csv | awk '{print $1}')
fend=$(head -1 test.csv | awk '{print $1}')
#echo $fstart $fend
gnuplot -persist -e "fmax=$fstart;f0=$fend" ./plot.gnu
