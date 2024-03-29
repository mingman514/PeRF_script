# D vs Multi B

TEST_NAME="test8"


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

run_pacer

MTU_LIST=(4096)
OP_LIST=("write")
QP_LIST=(1 5 10 15 20 25)

for MTU in ${MTU_LIST[@]}
do
  for OP in ${OP_LIST[@]}
  do

    reset_pids
    # Alone Flow
    run_bw.sh $OP 1 "-m $MTU" $(($CORE_START+1)) 1 > "$LOG_PATH/${OP}_${MTU}_0__msg"
    sleep 7
    kill_all

    for (( i=0; i<$LAT_TEST_ITER; i++));
    do 
      run_lat.sh $OP "-m $MTU" $CORE_START >> "$LOG_PATH/${OP}_${MTU}_0_lat"
      sleep 1
    done

    #for (( QP_NUM=1; QP_NUM <= 32 ; QP_NUM*=2 ));
    for QP_NUM in ${QP_LIST[@]}
    do

    reset_pids
 
    run_bw.sh $OP $QP_NUM "-m $MTU" $(($CORE_START+1)) 1 > "$LOG_PATH/${OP}_${MTU}_${QP_NUM}_bw"
    sleep 5
    for (( i=0; i<$LAT_TEST_ITER; i++));
    do 
      run_lat.sh $OP "-m $MTU" $CORE_START >> "$LOG_PATH/${OP}_${MTU}_${QP_NUM}_lat"
      sleep 1
    done
  
    kill_all


    done
  done
done


rename_log_folder $LOG_PATH $TEST_NAME
