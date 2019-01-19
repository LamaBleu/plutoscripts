#
# LamaBleu - Dec 2018
# 
N = floor(system("wc -l fm.csv"))
#N = floor(system("wc -l fm.csv")/100.)
set terminal dumb
fspan=fstop-fstart
set xlabel "freq. [MHz]"
set title  "  Fstart : " . sprintf("%06.3f", fstart) . " MHz  -  Fstop " . sprintf("%06.3f", fstop) . " MHz"
set format x "%1.1f"
set xrange[0: 100*ceil(N/100.0)]
set xtics (sprintf("%02.3f", fstart) 0, sprintf("%02.3f", fstart+fspan*0.25) 0.25*N, sprintf("%02.3f", fstart+fspan*0.5) 0.5*N, sprintf("%02.3f", fstart+fspan*0.75) 0.75*N, sprintf("%02.3f", fstop) N)
set lmargin 6
unset ytics
plot "fm.csv"
set terminal png size 1600 600
set output '/www/plot.png'
plot "fm.csv" using ($1) with lines lc rgb "#FF0000" title ""


