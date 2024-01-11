#!/bin/bash

# PERF_ENABLED가 정의되어 있지 않거나 0이면 "-TERM", 1이면 "-INT"를 나타내는 SIGNAL 변수 생성
if [ -z "$PERF_ENABLED" ] || [ "$PERF_ENABLED" -eq 0 ]; then
    SIGNAL="-TERM"
else
    SIGNAL="-INT"
fi

echo "Send $SIGNAL signal to Perftest Apps."
sudo kill $SIGNAL $(pgrep ib_write_) 2> /dev/null
sudo kill $SIGNAL $(pgrep ib_read_) 2> /dev/null
sudo kill $SIGNAL $(pgrep ib_send_) 2> /dev/null

#pkill ib_write_bw
#pkill ib_read_bw
#pkill ib_send_bw
#pkill ib_write_lat
#pkill ib_read_lat
#pkill ib_send_lat
