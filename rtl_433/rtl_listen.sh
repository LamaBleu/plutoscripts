#!/bin/sh
cp /remote/overlay/rtl.txt /www/rtl.txt
chmod 666 /www/rtl.txt
sleep 2
rtl_433 -d driver=plutosdr,uri=local: -l 110 -g 69  -C si -F json:/www/rtl.txt

