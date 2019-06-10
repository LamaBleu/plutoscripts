
This is a simple CLI to control basic settings of your pluto.  
Inspired from https://github.com/LamaBleu/moRFeus_listener.

You can control your pluto form shell, or access CLI from the LAN, by using socat or redirecting ports from the host computer to/from pluto.

Quick setup :
- Copy pluto_cli.sh script to your pluto on /usr/bin folder, then run "pluto_cli.sh" from pluto terminal console.

Main menu should appear, displaying available commands and status.


Local access (from terminal console, connected to pluto) :

# pluto_cli.sh 

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

     ****** RX ******
Freq       :  739509998
Samplerate :  2083336
BW         :  900000
Gain       :  73.000000 dB  (manual mode)
RSSI       :  126.75 dB


     ****** TX ******
Freq       :  2440000000
Samplerate :  2083336
BW         :  20000000
Att.       :  -10.000000 dB


Command : 



====================================================================

- Access from network :

1. Run following command on pluto command-line to give LAN access for pluto_cli.sh script:
      socat -t 2 TCP4-LISTEN:7777,fork,crlf,reuseaddr EXEC:/usr/bin/pluto_cli.sh,pty,stderr,echo=0

2. If the pluto is connected using wifi, juste use nc or telnet to access pluto_cli.
      nc 192.168.40.13 7778

3. From host computer use "nc 192.168.2.1 7777"

4. If you want to grant access to all computers on the LA you hav to redirect adequate ports on the computer hosting the Pluto.


LamaBleu (@fonera_cork) 06/2019

