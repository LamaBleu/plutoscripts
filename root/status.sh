cd /sys/bus/iio/devices/iio\:device1
while :
do
	reset
	echo "Freq       : " $(cat out_altvoltage0_RX_LO_frequency)
	echo "Samplerate : " $(cat in_voltage_sampling_frequency)
	echo "BW         : " $(cat in_voltage_rf_bandwidth)
	echo "Gain       : " $(cat in_voltage0_hardwaregain) " ("$(cat in_voltage0_gain_control_mode)" mode)"
	echo "Level      : " $(cat in_voltage0_rssi)
	sleep 3

done

