Scripts :
  
These scripts are intended to be run directly on PlutoSDR (ADALM-Pluto).  
Need 'jq' package (JSON parser) and gnuplot.  
However porting to PC should be an easy task. Using CSV format is probably better suited for gnuplot !  



  
#### rtl_listen.sh 
  
- Open a terminal console, start rtl_listen and keep it running.
- will create a /www/rtl.txt file (JSON format)
- /www/rtl.txt file is available at : http://192.168.2.1/rtl.txt
  
  
Example :
    
    {"time" : "2019-06-30 16:37:48", "model" : "Nexus Temperature/Humidity", "id" : 197, "channel" : 2, "battery" : "OK", "temperature_C" : 23.300, "humidity" : 68}
    {"time" : "2019-06-30 16:37:49", "brand" : "OS", "model" : "THGR122N", "id" : 161, "channel" : 1, "battery" : "LOW", "temperature_C" : 24.000, "humidity" : 62}
    
  
  
  
  
#### plot_id.sh <id_number>
  
- plot_id.sh will filter data from <id_number sensor> in /www/rtl.txt, then plot temperature and humidity graphs for the selected device.
- plot is available at : http://192.168.2.1/plot.png
  
  
  
#### Storing previous rtl_433 captures:  
Copy /www/rtl.txt to /remote if you are using NFS share.  
Add a line to /remote/myscript.sh : cp /remote/rtl.txt /www/rtl.txt 
rtl_listen.sh will then append new frames to existing rtl.txt file.  
  
  
#### Known issue : 
- /www/rtl.txt not updating --> chmod 666 /www/rtl.txt  


![image](https://user-images.githubusercontent.com/26578895/60450395-149e7800-9c2a-11e9-993c-c5600ed4106d.png)
