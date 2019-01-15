# Trying to reproduce - so far no luck.
# https://wiki.analog.com/resources/tools-software/linux-software/libiio/iio_readdev
#
iio_attr -u local:   -D loopback 1
iio_attr -c cf-ad9361-dds-core-lpc altvoltage0 frequency 5000
iio_attr -c cf-ad9361-dds-core-lpc altvoltage1 frequency 5000
iio_attr -c cf-ad9361-dds-core-lpc altvoltage2 frequency 5000
iio_attr -c cf-ad9361-dds-core-lpc altvoltage3 frequency 5000

iio_attr -c cf-ad9361-dds-core-lpc altvoltage3 scale 0.4
iio_attr -c cf-ad9361-dds-core-lpc altvoltage2 scale 0.4
iio_attr -c cf-ad9361-dds-core-lpc altvoltage0 scale 0.4
iio_attr -c cf-ad9361-dds-core-lpc altvoltage1 scale 0.4
sleep 1
iio_readdev -u local: -b 256 -s 1024 cf-ad9361-lpc > samples.bin
sleep 0.5
echo 
hexdump -x -n 128 ./samples.bin 
echo
wc -c samples.bin
sleep 5
gnuplot ./samples.gnu
