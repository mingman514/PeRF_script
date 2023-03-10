# B vs M, D

source ./utils.sh
source ./config.sh
export BASE_DIR=$(pwd)
export PATH=$PATH:$(pwd)/script
export PATH=$PATH:$(pwd)/bin
#export SERVER_IP=10.0.102.2
echo "Server IP: $SERV_IP"


# log file format: ${TEST_NAME}_${TIMESTAMP}
TEST_NAME="test1"

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

MTU_LIST=(4096)
if [ $MODE -eq 0 ]; then
  OP_LIST=("write" "send" "read")
else
  OP_LIST=("write")
fi

run_pacer

for MTU in ${MTU_LIST[@]}
do
  for OP in ${OP_LIST[@]}
  do
  reset_pids

  # ALONE
  ## 1. Run BW
  run_bw.sh $OP 1 "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_alone_bw"
  sleep 15

  kill_nth_process 0

  ## 2. Run Msg
  run_msg.sh $OP 1 "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_alone_msg"
  sleep 15

  kill_nth_process 1

  ## 3. Run Lat
  for (( i=0; i<$LAT_TEST_ITER; i++));
  do 
    run_lat.sh $OP "-m $MTU" >> "$LOG_PATH/${OP}_${MTU}_alone_lat"
    sleep 1
  done
 
  
  # COMPETED
  reset_pids

  ## 1. Run BW & Msg
  run_bw.sh $OP 1 "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_competed_bw1"
  sleep 2
  run_msg.sh $OP 1 "-m $MTU"  > "$LOG_PATH/${OP}_${MTU}_competed_msg"
  sleep 15

  kill_all
  reset_pids
  run_pacer

  ## 2. Run BW & Lat
  run_bw.sh $OP 1 "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_competed_bw2"
  sleep 2
  for (( i=0; i<$LAT_TEST_ITER; i++));
  do 
    run_lat.sh $OP "-m $MTU" >> "$LOG_PATH/${OP}_${MTU}_competed_lat"
    sleep 1
  done

  kill_all
  done
done


rename_log_folder $LOG_PATH $TEST_NAME
