echo "Converting /www/record.wav to /www/record.csv... wait ..."
multimon-ng -q -t wav -a DUMPCSV  /www/record.wav > /www/record.csv
gnuplot -e "plot_data_file='/www/record'" /root/multimon-ng/csv_png.gnu


