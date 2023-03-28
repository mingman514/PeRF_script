source ./config.sh
source ./utils.sh

trap stop_program INT

TYPE="bw"   # msg or bw
PORT=9000
READ_PORT=2011
export MAX_CORE=13   # to align with num of apps

app_num=(20 30 50 100 200 300 400 500 1000)    # in ascending order
app_num=(1 100 200 300 400 500)    # in ascending order
app_num=(250 256 500 1000 1024)    # in ascending order

prev_num=0
start_core=3  # 0: perf_main  1: print   2: msg   3: delay
cur_core=$start_core
cur_id=0
reset_pids
for app_num in ${app_num[@]}
do
  echo
  echo "<<<< APP Num: $app_num >>>>"
  echo "***** Press Enter to Start Next *****"
  echo
  read input

  cur_num=$(($app_num-$prev_num))

  for (( i=0; i<$cur_num; i++));
  do
    PERF_READ_PORT=$READ_PORT ./script/run_$TYPE.sh write 8 "-p $PORT --app_id=$cur_id -D 20" $cur_core 1 &
    READ_PORT=$(($READ_PORT+20))
    echo "READ PORT: $READ_PORT"
    #if [ $READ_PORT -gt 10000 ]; then
    #  READ_PORT=2011
    #fi
    PORT=$(($PORT+1))
    cur_core=$(($cur_core+1))
    if [ $cur_core -gt $MAX_CORE ]; then
      cur_core=$start_core
    fi
    echo "############## CUR_CORE: $cur_core ##########"
    cur_id=$(($cur_id+1))
    
    if [ $cur_id -gt 300 ]; then
      sleep 1
    elif [ $cur_id -gt 500 ]; then
      sleep 2
    else
      sleep 0.3
      #echo "Enter to start new flow"
      #read input
    fi
  done
  prev_num=$app_num
  read input
  echo "---------------------------START--------------------------------"
  read input
  echo "----------------------------END---------------------------------"
done

echo "TEST DONE! Press Enter to Stop."
read input
./kill_ib.sh
