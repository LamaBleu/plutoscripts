Guess why timems tool?  


Just curious, playing with timestamps under bash, found that millisecond accuracy is not available on pluto.  
It's OK from python or using adjtimex (which is not implemented by default)  


    # date  
    Sat Aug 17 20:37:57 UTC 2019  
    # date +%s  
    1566074294  
    # date +%s%N  
    1566074300%N  
    # date +%s%m  (0.01 second)
    156607430508
 



So I compiled timems.c, result :  

    # timems
    1566073573.926


Another workaround is to enable : CONFIG_FEATURE_DATE_NANO=y for busybox config before compiling firmware  

    # date +%s.%N
    1566073581.999486578
 

For lazy plutoers, timems executable for v0.30 is provided here.
