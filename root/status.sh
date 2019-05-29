cd /sys/bus/iio/devices/iio\:device1
while :
do
	reset
	echo "     ****** RX ******"
	echo "Freq       : " $(cat out_altvoltage0_RX_LO_frequency)
	echo "Samplerate : " $(cat in_voltage_sampling_frequency)
	echo "BW         : " $(cat in_voltage_rf_bandwidth)
	echo "Gain       : " $(cat in_voltage0_hardwaregain) " ("$(cat in_voltage0_gain_control_mode)" mode)"
	echo "RSSI       : " $(cat in_voltage0_rssi)
	echo
	echo 
	echo "     ****** TX ******"
        echo "Freq       : " $(cat out_altvoltage1_TX_LO_frequency)
        echo "Samplerate : " $(cat out_voltage_sampling_frequency)
        echo "BW         : " $(cat out_voltage_rf_bandwidth)
        echo "Att.       : " $(cat out_voltage0_hardwaregain)
sleep 3

done

