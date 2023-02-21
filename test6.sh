# M vs Multi M

TEST_NAME="test6"


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


trap stop_program INT
#--------------------------------------

run_pacer

MTU_LIST=(4096)
OP_LIST=("write")
QP_LIST=(1 4 8 12 16 20 24)

for MTU in ${MTU_LIST[@]}
do
  for OP in ${OP_LIST[@]}
  do
    #for (( QP_NUM=1; QP_NUM <= 128 ; QP_NUM*=2 ));
    for QP_NUM in ${QP_LIST[@]}
    do

      reset_pids

      run_msg.sh $OP 1 "-m $MTU" $CORE_START 1 > "$LOG_PATH/${OP}_${MTU}_${QP_NUM}_single"
      sleep 2
      if [ $QP_NUM -lt 10 ]; then
        run_msg.sh $OP $QP_NUM "-m $MTU" $(($CORE_START+1)) $(($QP_NUM+1)) > "$LOG_PATH/${OP}_${MTU}_${QP_NUM}_multi"
      else
        run_msg.sh $OP $QP_NUM "-m $MTU --qps_in_thrd 0" $(($CORE_START+1)) $(($QP_NUM+1)) > "$LOG_PATH/${OP}_${MTU}_${QP_NUM}_multi"
      fi
      sleep 40

    kill_all


    done
  done
done


rename_log_folder $LOG_PATH $TEST_NAME
