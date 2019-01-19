

LamaBleu 15/01/2018 


APPLICATIONS
=============

- iio tools : iio-info, libiio 0.17
- CW generator (python) (FG8OJ for CW processing code : https://github.com/fg8oj/cwkeyer)
- SoapySDR + SoapyRemote 0.6.1 (Pothosware https://github.com/pothosware/SoapySDR) 
- LeanTRX ( + DATV TX scripts)  (F4DAV and PABR team http://www.pabr.org/radio/leantrx/leantrx.en.html)
- Python 2.7 (+numpy, also  including iio and SoapySDR bindings)
- rxtools : rx_sdr, rx_fm, rx_power ( Robert X. Seger https://github.com/rxseger/rx_tools)
- LUAradio (Vanya Sergeev http://luaradio.io)
- csdr ( + nmux) (Simonyi Károly College for Advanced Studies https://github.com/simonyiszk/csdr)
- gnuplot + libpng  
- Busybox utilities  : sox, socat, netcat, timeout, ntpd and more (at, timeout to perform scheduled tasks or end a task).
- Retrogram  (Peter Rakesh https://github.com/r4d10n/retrogram-plutosdr)
- multimon-ng (Elias Önal https://github.com/EliasOenal/multimon-ng/)
- OpenWebRX (András Retzler HA7ILM https://sdr.hu)



- USB mass storage : transfer files to/from pluto.
Hard to explain in few words ! To copy file to/from pluto, you can use the USB Mass Storage from host computer and /gadget on Pluto side.

Procedure:
- copy files to PlutoSDR drive
- eject (unmount) the drive. Will re-appear few seconds later.
- on the pluto side, from SSH run usb-drive.sh script.
- a copy of PlutoSDR will appear on /gadget folder.

You have to sync /gadget <--> USB mass storage each time you copy file.
Just to be sure, check files timestamp.

I agree, this need some training ;) 




CW keyer:
=========

The python script comes from Bertrand FG8OJ, adapted for Pluto. It's a smooth mix of libiio, bash-iio  and iio_attrib use ;)
Run following python script  located in /root : python /root/CW-pluto.py -f 144350000 -w 13 "CQ CQ CQ TEST"
  --> frequency -f parameter can be omitted, default frequency is 434 MHz

LUARADIO : 
==========

Luaradio is a LUA application to demodulate and process SDR signals.
It works using scripting, easy to understand.
However LUAradio soesn't seems to be maintained anymore. more : http://luaradio.io
(last minute: the author of LUAradio announces a 1.0 version to be released in 2019)

 
It's best to change directory before use (cd /root/luaradio), at least when running examples scripts.
noaa_pluto.lua : rate 11025
nbfm_pluto.lua : rate 48000
wbfm_mono_pluto.lua : rate 48000

Examples : luaradio nbfm_pluto.lua 466205000 , luaradio wbfm_mono_pluto.lua 105500000 

POCSAG:
luaradio pocsag_pluto.lua 466050000


----
Record 5 minutes NBFM on 466.205MHz (48000Hz):

# timeout -t 300 -s SIGINT ./luaradio nbfm_pluto.lua 466205000
  Recording from 466.205 to  /www/record.wav 
  [INFO] Auto setting Buffer Size: 262144

Wav file is copied to http://pluto.local/record.wav
File can be downloaded or played through VLC (open network stream: http://192.168.2.1/record.wav)
or mplayer : mplayer -cache 1024 -quiet -rawaudio http://192.168.2.1/record.wav

----
Record NOAA :

timeout -t 700 -s SIGINT luaradio noaa_pluto.lua 137100000 /www/noaa.wav

----




RX_SDR and CSDR
===============
CSDR (and libcsdr) is a really nice tool dedicated to signal processing on SDR based on piped commands.
libsdr is the main sock of OpenWebRX. nmux is also included.
Refer to libsdr/openwebRX docs. Please take also few minutes to read this long post from HA7LIM : https://blog.sdr.hu/support



All these commands are very long, in one line only, take care !

Examples :

* Record 466.175 NBFM to /www/record.wav  (wav file is on /www , or http://192.168.2.1/record.wav):

rx_sdr -F CF32 -f 466175000 -s 2400000 -g 70 - | csdr fir_decimate_cc 50 0.005 HAMMING | csdr fmdemod_quadri_cf | csdr limit_ff | csdr deemphasis_nfm_ff 48000 | csdr fastagc_ff | csdr convert_f_i16 | sox -t raw -e signed -c 1 -b 16 -r 48000 - /www/record.wav



* Stream audio to 192.168.2.1:4444:
( use "nc 192.168.2.1 4444 |  mplayer -cache 1024 -quiet -rawaudio samplesize=2:channels=1:rate=48000 -demuxer rawaudio -" on the host computer)

rx_sdr -F CF32 -f 466175000 -s 2400000 -g 70 - | csdr fir_decimate_cc 50 0.005 HAMMING | csdr fmdemod_quadri_cf | csdr limit_ff | csdr deemphasis_nfm_ff 48000 | csdr fastagc_ff | csdr convert_f_i16 | nmux -p 4444 -a 10.40.0.155


* Receive POCSAG NBFM 

Pluto :

rx_sdr  -F CF32 -s 2400000 -f 466175000 -g 50 - | csdr fir_decimate_cc 50 0.005 HAMMING | csdr fmdemod_quadri_cf  | csdr limit_ff | csdr deemphasis_nfm_ff 48000 | csdr fastagc_ff | csdr convert_f_i16  | netcat -l -p 4444

Pc-client :

nc 192.168.2.1 4444 | mplayer -cache 1024 -quiet -rawaudio samplesize=2:channels=1:rate=48000 -demuxer rawaudio -
(using nc, can be remplaced by netcat, or better nmux)



* Receive WBFM using mplayer on the computer side :
A wav file is created on http://192.168.2.1/record.wav

Pluto :
 rx_sdr  -F CF32 -s 2400000 -f 105100000 -g 20 -  | csdr fir_decimate_cc 10 0.05 HAMMING | csdr fmdemod_quadri_cf | csdr fractional_decimator_ff 5  | csdr deemphasis_wfm_ff 48000 50e-6 | csdr convert_f_i16 > /www/record.wav

- PC client, get the file  at http://192.168.2.1/record.wav or listen   :
mplayer -cache 1024 -quiet -rawaudio samplesize=2:channels=1:rate=48000 -demuxer rawaudio http://192.168.2.1/record.wav

* Variant, using rx_sdr -F CF32 , csdr, nmux or netcat (see nbfm-rx.sh and wbfm-rx.sh scripts):
Audio is streamed to port pluto.local:4444

Pluto : 
(WBFM ) rx_sdr -F CF32 -s 2400000 -f 105100000 -g 70 - | csdr fir_decimate_cc 10 0.05 HAMMING | csdr fmdemod_quadri_cf | csdr fractional_decimator_ff 5  | csdr deemphasis_wfm_ff 48000 50e-6 | csdr convert_f_i16 | nmux -a 192.168.2.1 -p 4444

/root/nbfm-rx.sh script :

(NBFM) rx_sdr -F CF32 -s 2400000 -f 466175000 -g 50 - | csdr fir_decimate_cc 50 0.005 HAMMING | csdr fmdemod_quadri_cf  | csdr limit_ff | csdr deemphasis_nfm_ff 48000 | csdr fastagc_ff | csdr convert_f_i16  | netcat -l -p 4444

/root/wbfm-rx.sh script, audio 48000Hz
3MS/s  sample rate : 
rx_sdr -F CF32 -s 3000000 -f 105100000 -g 70 - | csdr fir_decimate_cc 12 0.06 HAMMING | csdr fmdemod_quadri_cf | csdr fractional_decimator_ff 5  | csdr deemphasis_wfm_ff 48000 60e-6 | csdr convert_f_i16 | nmux -a 192.168.2.1 -p 4444

PC: 
nc 192.168.2.1 4444 | mplayer -cache 1024 -quiet -rawaudio samplesize=2:channels=1:rate=48000 -demuxer rawaudio -


GNUPLOT
=======

You can create plots directly from the Pluto
Generated plot is displayed on the console using ASCII-art (vintage !).
and PNG version is available here : http://192.168.2.1/plot.png


- Plot RF signal spectrum : use signal.sh
signal.sh 1800 2600 25  55 --> plot from 800 to 2600MHz, spacing 25kHz, gain 55 (from 0 to 73, can be omitted, default 70)

Notes : signal.sh uses rx_power to get signal value. 
At this moment it will only perform one pass ( -1 ) because of CSV file formatting.
A full sweep is performed in less than 10 seconds. Time can be increased to improve result.
Example : https://imgur.com/3K8bRpf  https://imgur.com/7FgnFIT

- Plot audio record coming from /www/record.wav :
Run plot-wav.sh script. 
Will draw a plot you can view on http://192.168.2.1/plot.png
Plot processing can take lot of time, be patient.
Example : https://imgur.com/hgIMeWO

RX_FM
=======

rx_fm seems buggy using nfm mode ! But works well using wbfm. TBC .( confirmed !)
Stream to the host computer using nc, netcat, or nmux.
Wav file can also be saved to file, please refer to rx-tools doc.

Pluto: 

rx_fm  -M fm -s 170k -A fast -r 32k -l 0 -E deemp -f 105100000 -g 70 - | nc -l -p 4444   (WBFM)
rx_fm  -M nfm -A fast -r 32k -l 0 -E deemp -f 466207000 -g 70 - | nc -l -p 4444    (NFM)

streaming via nmux :

rx_fm -M fm -s 170k -A fast -r 32k -l 0 -E deemp -f 105100000 -g 70 - | nmux -a 192.168.2.1 -p 4444


Client:

nc 192.168.2.1 4444 | aplay -r 32k -f S16_LE -t raw -c 1

nc 192.168.2.1 4444 | mplayer -cache 1024 -quiet -rawaudio samplesize=2:channels=1:rate=32000 -demuxer rawaudio -




LEANTRX and DATV :
=================

LeanTRX home page is available here : http://192.168.2.1/leantrx (or pluto.local/leantrx)

Scripts : to send DATV have a look to scripts in /root/DATV folder ! Please respect rules/laws regarding RF transmission.

When receiving DATV using from the DVBRX page(dvbrx.html), the TS stream is now redirected to 192.168.2.1:4444 using nmux.
With a bit of luck it is possible to view the stream using VLC on the host computer running :  
      nc 192.168.2.1 4444 | cvlc -

However it doesn't always work, depending on the stream (works well using MPEG4 stream sent from RPiDATV, 333kS/s).
Try replacing cvlc by mplayer.
See another example below, and have a look to /root/datv-rx-leandvb.sh script to get more inspiration.


MPEG4-ts sample file is no more provided on USB Mass storage for this light version.
You have to download it and copy to the USB Mass storage.

Send MPEG2-ts sample file to DVB-S FtA receiver:
- too big to fit on the flash : you have to download it first, using mpeg2-download.sh script or manually :
    . link : https://github.com/LamaBleu/Pluto-DATV-test/raw/master/samples/MPEG2-lalinea.ts
    . copy the file to the USB Mass Storage THEN eject the USB volume to perform a sync.
    . now you can run datv-tx-mpeg2.sh script ( will transmit on 970MHz, 1000kS/s 7/8)
    . Use only on interior, for test purposes, short antenna, at your own risk (prohibited freq).

Send DATV from shell :
 leandvbtx < /gadget/rpidatv.ts | leaniiotx -f 970000000 --bufsize 32768 --nbufs 32 --bw 1e6 -v



Receive DATV  using LeanTRX and VLC :

- Send DATV RF signal using RpiDATV :  435MHz 250 kS/s FEC 1:2
- Receive on Pluto side (in one line):
 leaniiorx --bufsize 65536 --nbufs 32 -f 435e6 -s 2e6 --bw 250e3 -v | leansdrserv --info3-httpd 8003 leandvb --s16  -f 2e6 --tune 0 --sr 250e3 --sampler rrc --rrc-rej 20 --const QPSK --standard DVB-S --cr 1/2 --fastlock -v --json --anf 0 --fd-info 3 --fd-const 3 --fd-spectrum 3 | nc -l -p 4444 192.168.2.1
- Computer side :  nc 192.168.2.1 4444 | cvlc -


OPENWEBRX
=========
Was not on my initial plan to add OpenWebRX on this firmware, but I found 2 MB to fill the flash ;) 
Really easy to implement.
Launch manually by running 'openwebrx.sh' script. 
By running 'openwebrx.sh 144500000' you will start on 144.5 MHz ... 
Frequency can be omitted, will start using the last frequency.

I DO NOT plan to make it run at boot, or in background sorry. Please install Plutoweb instead ;)




***** DEV-CORNER : ACCESS TO PLUTO DEVICE  ********



# iio_info -s
Library version: 0.16 (git tag: v0.16)
Compiled with backends: local xml ip usb serial
Available contexts:
	0: Local devices [local:]


NEW URI is local: !

status.sh script will show RX status at anytime.



From shell (on pluto):
======================

get RX gain:
cat /sys/bus/iio/devices/iio\:device1/in_voltage0_hardwaregain

get gain mode:
cat /sys/bus/iio/devices/iio\:device1/in_voltage0_gain_control_mode

get RX freq:
cat /sys/bus/iio/devices/iio\:device1/out_altvoltage0_RX_LO_frequency

Set RX gain:
cd /sys/bus/iio/devices/iio:device1
echo "58" > in_voltage0_hardwaregain


From shell again but using iio 
==============================

Change TX freq:
iio_attr -q -c ad9361-phy altvoltage1 frequency 435200000

Get/set RX freq
iio_attr -q -c ad9361-phy altvoltage0 frequency
iio_attr -q -c ad9361-phy altvoltage0 frequency 435200000

Use following commands to get more infos on device :

iio_attr -u local: -B
iio_attr -u local: -c
iio_attr -u local: -c ad9361-phy


Python
======

Python test scripts to verify iio and SoapySDR bindings are working :
-->  have a look to /root/python folder
Note: on the light-version only, some python scripts invoking numpy module are no more working.



- Run scripts from USB drive.

Running the pluto powered from the right USB connector, you can connect USB drive (or Wifi dongle) to
the left USB connector.

It's then possible to run scripts, and save resulting files (WAV captures, CSV files) on USB key.
It's also possible to perform update or add system files to the Pluto.

Please have a look to pages 29 to 31 of this precious doc : 
https://archive.fosdem.org/2018/schedule/event/plutosdr/attachments/slides/2503/export/events/attachments/plutosdr/slides/2503/pluto_stupid_tricks.pdf




