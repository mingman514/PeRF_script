source ./config.sh
source ./utils.sh

trap stop_program INT

TYPE="bw"   # msg or bw
PORT=9000
READ_PORT=2011

./script/run_$TYPE.sh write 1 "" 2 $(($MAX_CORE-1)) &
echo
echo "<<<< APP Num: 1 >>>>"
read input

for (( APP_NUM=1; APP_NUM<1024; APP_NUM*=2));
do
  reset_pids

  for (( i=0; i<$APP_NUM; i++));
  do
    PERF_READ_PORT=$READ_PORT ./script/run_$TYPE.sh write 1 "-p $PORT" 2 $(($MAX_CORE-1)) > /dev/null &
    READ_PORT=$(($READ_PORT+5))
    if [ $READ_PORT -gt 10000 ]; then
      READ_PORT=2011
    fi
    PORT=$(($PORT+1))
    sleep 0.3
  done

  echo "<<<< APP Num: $(($APP_NUM*2)) >>>>"
  echo "***** Press Enter to Start Next *****"
  read input

  #kill_nth_process 0
  #sleep 0.5

done

echo "TEST DONE."
./kill_ib.sh
