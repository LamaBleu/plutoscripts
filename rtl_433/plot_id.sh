#!/bin/sh
id=$1
eval "jq -jr '.time, \",\", .id==$id, \",\", .temperature_C , \",\", .humidity, \"\n\"' /www/rtl.txt | grep true > rtl_433.csv"
gnuplot -e "id=$id" /root/rtl_433/temp.gnu 2>/dev/null
echo "Full PNG plot  : http://pluto.local/plot.png or http://192.168.2.1/plot.png"


