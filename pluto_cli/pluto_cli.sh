#!/bin/sh




function get_status () {

cd /sys/bus/iio/devices/iio\:device1

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
	echo
	echo

}



function display_cmds () {
echo "
*** ADALM-Pluto remote control
*** LamaBleu 05/2019

   Pluto listener commands :
   -----------------------

F 123456789  : set frequency (RX/TX)
BW : set Bandwidth (RX/TX)
SR : set Samplerate (RX/TX)
TXF : set TX frequency
TXBW : set TX bandwidth
TXATT [-89:0] : set TX attenuation ( 0 = max power)
RXF : set RX frequency
RXBW : set RX bandwidth
RXGAIN [0-73]: set RX gain
S : display status
H : display commands list
X or Q : disconnect
KK : disconnect and KILL server
"

}

display_cmds
get_status




while :
do
command=""
freq=""
pluto_com=""
arg1=""
power=""
mode=""

echo -n "Command : "
read pluto_com
reset
command=$(echo $pluto_com | awk '{print $1}')
arg1=$(echo $pluto_com | awk '{print $2}')
#arg1=${arg1//[![:digit:]]}
#echo $command

echo
case $command in
	F) echo "    **** set Frequency $arg1"
		if [ -z "$arg1" ]; then echo "**** noarg !"; fi
		echo $arg1
		echo
		/usr/bin/iio_attr -q -c ad9361-phy altvoltage1 frequency $((arg1)) 1>/dev/null
		/usr/bin/iio_attr -q -c ad9361-phy altvoltage0 frequency $((arg1)) 1>/dev/null
		get_status;
		;;
	[XxQq]) echo "       **** DISCONNECT "
		echo "       Goodbye. "
		exit 0;
		;;
	[Ss]) get_status;
		;;
	[Hh]) display_cmds;
		;;
	KK) echo "Disconnect and kill server - Goodbye forever !"
		sudo killall socat
		exit 0;
		;;
	BW ) if [ -z "$arg1" ]; then echo "**** noarg !"; fi
		echo "    **** set TX/RX Bandwidth $arg1 "
		echo
		iio_attr -q -c ad9361-phy voltage0 rf_bandwidth $((arg1)) 1>/dev/null
		get_status;
		;;
	TXF ) echo "    **** set TX Frequency $arg1"
		if [ -z "$arg1" ]; then echo "**** noarg !"; fi
		echo
		sleep 1
		/usr/bin/iio_attr -a -q -c ad9361-phy altvoltage1 frequency $((arg1)) 1>/dev/null
		get_status;
		;;
	TXBW ) if [ -z "$arg1" ]; then echo "**** noarg !"; fi
		echo "    **** set TX Bandwidth $arg1 "
		echo
		iio_attr -a -q -c -o ad9361-phy voltage0 rf_bandwidth $((arg1)) 1>/dev/null
		get_status;
		;;
	TXGAIN ) echo "    **** set TX attenuation  $arg1"
		echo
		/usr/bin/iio_attr -a -q -c -o ad9361-phy voltage0 hardwaregain $((arg1)) 1>/dev/null
		get_status;		
		;;
	RXF ) echo "    **** set RX Frequency $arg1"
		if [ -z "$arg1" ]; then echo "noarg"; fi
		echo $arg1
		sleep 1
		/usr/bin/iio_attr -a -q -c ad9361-phy altvoltage0 frequency $((arg1)) 1>/dev/null
		get_status;
		;;
	RXBW ) if [ -z "$arg1" ]; then echo "**** noarg !"; fi
		echo "    **** set RX Bandwidth $arg1 "
		echo
		iio_attr -a -q -c -i ad9361-phy voltage0 rf_bandwidth $((arg1)) 1>/dev/null
		get_status;
		;;
	RXGAIN ) echo "    **** set RX gain  $arg1"
		echo
		/usr/bin/iio_attr -a -q -c -i ad9361-phy voltage0 gain_control_mode manual 1>/dev/null
		/usr/bin/iio_attr -a -q -c -i ad9361-phy voltage0 hardwaregain $((arg1)) 1>/dev/null
		get_status;		
		;;
	SR) echo "    **** set TX/RX Samplerate  $arg1"
		/usr/bin/iio_attr -a -q -c ad9361-phy voltage0 sampling_frequency $((arg1)) 1>/dev/null
		get_status;		
		;;
	f ) 	freq=$(/usr/bin/iio_attr -a -q -c ad9361-phy altvoltage0 frequency)  1>/dev/null
		echo "    **** Frequency :  $freq"		
		;;
	*) command=""
		echo "*** error 404 !"
		freq=""
		arg1=""
		#get_status;
		;;
esac


command=""
freq=""
#pluto_com=""
arg1=""

done

