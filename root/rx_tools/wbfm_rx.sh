
rx_fm -f 105.1M -M wbfm -s 170k -r 48k -A fast -l 0 -E deemp -g 70 | sox -t raw -e signed -c 1 -b 16 -r 48000 - /www/record.wav
