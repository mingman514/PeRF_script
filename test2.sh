# 1MB B vs 1GB B

TEST_NAME="test2"


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

for MTU in ${MTU_LIST[@]}
do
  for OP in ${OP_LIST[@]}
  do
    for (( TX=1; TX <= 6 ; TX++ ));
    do
      reset_pids
  
      ###################
      # POLLING
      ###################
      run_bw_1GB.sh $OP 1 "-m $MTU -t $TX" > "$LOG_PATH/${OP}_${MTU}_${TX}_1GB"
      sleep 2

      run_bw.sh $OP 1 "-m $MTU -t $TX" > "$LOG_PATH/${OP}_${MTU}_${TX}_1MB"
      sleep 40

      kill_all
  
#      reset_pids
  
      ###################
      # EVENT DRIVEN
      ###################
      ## ALONE
#      run_bw.sh $OP 1 "-m $MTU -e" > "$LOG_PATH/${OP}_${MTU}_tx${TX}_1MB_poll"
#      sleep 10
#      kill_all
#  
#      run_bw_1GB.sh $OP 1 "-m $MTU -e" > "$LOG_PATH/${OP}_${MTU}_tx${TX}_1GB_poll"
#      sleep 20
#      kill_all
  
    done
  done
done


rename_log_folder $LOG_PATH $TEST_NAME
