# Background Traffic Test

TEST_NAME="test0"

source ./utils.sh
source ./config.sh
export BASE_DIR=$(pwd)
export PATH=$PATH:$(pwd)/script
export PATH=$PATH:$(pwd)/bin

#export SERVER_IP=10.0.102.2
echo "Server IP: $SERV_IP"

# log file format: ${TEST_NAME}_${TIMESTAMP}

LOG_PATH=$BASE_DIR/log/tmp
if [ -d $LOG_PATH ]; then
  sudo rm -r $LOG_PATH
fi
mkdir $LOG_PATH

if [[ -z $LAT_TEST_ITER ]];then
  LAT_TEST_ITER=1
fi
echo "LAT ITER: $LAT_TEST_ITER times"

trap stop_program INT
#--------------------------------------

MTU_LIST=(1024 2048 4096)
OP_LIST=("write")

#MSG_SIZE=(4096 1048576)
MSG_SIZE=(0 256 512 1024 2048 4096 8192 16384 1048576 1073741824)

run_pacer

for MTU in ${MTU_LIST[@]}
do
  for OP in ${OP_LIST[@]}
  do
    for SIZE in ${MSG_SIZE[@]}
    do
    reset_pids

    if [ $SIZE -le 1048576 ]; then 
    #  if [ $SIZE -le 1024 ]; then
    #    run_bw.sh $OP 1 "-m $MTU -s $SIZE -l 32" > "$LOG_PATH/${OP}_${MTU}_${SIZE}_bw"
    #  else
        run_bw.sh $OP 1 "-m $MTU -s $SIZE -l 64 -t 512" > "$LOG_PATH/${OP}_${MTU}_${SIZE}_bw"
    #  fi
      sleep 5
    else
      run_bw_1GB.sh $OP 1 "-m $MTU -l 64 -t 512" > "$LOG_PATH/${OP}_${MTU}_${SIZE}_bw"
      sleep 20
    fi
    
    for (( i=0; i<$LAT_TEST_ITER; i++));
    do 
      run_lat.sh $OP "-m $MTU -n 1000000" >> "$LOG_PATH/${OP}_${MTU}_${SIZE}_lat"
      sleep 1
    done


    run_msg.sh $OP 1 "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_${SIZE}_msg"
    sleep 10
  
    kill_all

    done
  done
done


rename_log_folder $LOG_PATH $TEST_NAME
