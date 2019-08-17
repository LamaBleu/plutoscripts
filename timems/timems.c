#include <stdio.h>
#include <time.h>
void main (void){
    long            ms; 
    time_t          s; 

    struct timespec spec;
    clock_gettime(CLOCK_REALTIME, &spec);
    s  = spec.tv_sec;
    ms = (spec.tv_nsec / 1.0e6); 
    printf("%d.%03d\n", s, ms);      
return 0;
}

