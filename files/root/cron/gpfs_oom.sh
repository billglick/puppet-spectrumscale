#!/bin/bash

PGREP=$(command -v pgrep)

$PGREP -f /usr/lpp/mmfs/bin/mmfsd \
| while read PID; do 
    echo -1000 > /proc/$PID/oom_score_adj
done
