Build pow tool : 

      gcc -std=gnu99 -g -o pow pow.c -liio -lm -Wall -Wextra
      
Test : ./pow -l 430600000 -r 40 -f 3
   result : 430600000 2.49 95.75
            freq (Hz), signal (dB),(dB)
            
 
** Test a filter using moRFeus :
 - use signal.sh
 - edit fstart step fend in Hz. at the beginnening of the file
 - edit the IP adress to moRFeus_listener (127.0.0.1 for local)
 - launch signal.sh.
 - result file is test.csv
 - launch plot.sh to draw plot.
   
   
You can also edit signal.sh to change gain ( -r) and samplerate (-f) for pow tool.
Bandwidth is set to 200kHz.
