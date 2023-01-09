# M vs D

source ./utils.sh
source ./config.sh
export BASE_DIR=$(pwd)
export PATH=$PATH:$(pwd)/script
export PATH=$PATH:$(pwd)/bin
#export SERVER_IP=10.0.102.2
echo "Server IP: $SERV_IP"


# log file format: ${TEST_NAME}_${TIMESTAMP}
TEST_NAME="test4"

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

run_pacer

MTU_LIST=(1024 2048 4096)
OP_LIST=("write")

for MTU in ${MTU_LIST[@]}
do
  for OP in ${OP_LIST[@]}
  do
  reset_pids

  # ALONE
  run_msg.sh $OP 1 "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_alone_msg"
  sleep 7

  kill_all

  for (( i=0; i<$LAT_TEST_ITER; i++));
  do 
    run_lat.sh $OP "-m $MTU" >> "$LOG_PATH/${OP}_${MTU}_alone_lat"
    sleep 1
  done

  
  # COMPETED
  reset_pids

  run_msg.sh $OP 1 "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_competed_msg"
  sleep 5
  
  for (( i=0; i<$LAT_TEST_ITER; i++));
  do 
    run_lat.sh $OP "-m $MTU"  >> "$LOG_PATH/${OP}_${MTU}_competed_lat"
    sleep 1
  done

  kill_all

  done
done


rename_log_folder $LOG_PATH $TEST_NAME
