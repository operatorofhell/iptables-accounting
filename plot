set datafile separator ","
set xdata time
set timefmt "%s"

set terminal x11 nopersist
set grid

set xlabel "time"
set ylabel "bps"

set format y '%.0s%c'

set autoscale y


plot "ACC_OUT_2017-03-14_0.0.0.0-0_8.8.8.8" using 1:2 with lines lw 2 lt 3
