# D vs Multi B

TEST_NAME="test8"


source ./utils.sh
source ./config.sh
export BASE_DIR=$(pwd)
export PATH=$PATH:$(pwd)/script
#export SERVER_IP=10.0.102.2
echo "Server IP: $SERVER_IP"


# log file format: ${TEST_NAME}_${TIMESTAMP}

LOG_PATH=$BASE_DIR/log/tmp
if [ -d $LOG_PATH ]; then
  sudo rm -r $LOG_PATH
fi
mkdir $LOG_PATH


trap stop_program INT
#--------------------------------------

MTU_LIST=(4096)
OP_LIST=("write" "send" "read")

for MTU in ${MTU_LIST[@]}
do
  for OP in ${OP_LIST[@]}
  do
    for (( QP_NUM=1; QP_NUM <= 32 ; QP_NUM*=2 ));
    do

    reset_pids
 
    run_bw.sh $OP $QP_NUM "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_${QP_NUM}_bw"
    sleep 5
    run_lat.sh $OP "-m $MTU" > "$LOG_PATH/${OP}_${MTU}_${QP_NUM}_lat"
  
    kill_all


    done
  done
done


rename_log_folder $LOG_PATH $TEST_NAME
