# EX) ./run_msg.sh write 3

source ./config.sh > /dev/null 2>&1
TYPE=$1
ITER=$2
PORT=9000

if [ $IS_CLIENT -eq 1 ];then
  sleep 0.3
fi

CMD="$BASE_DIR/bin/ib_${TYPE}_bw -d ${DEV} -F --run_infinitely -D 2 -l 32 -s 16 -p $PORT $SERVER_IP -q $ITER --report_gbits $3"

if [ "$ITER" -ge 2 ]
then
  CMD+=" --thrd_per_qp --qps_in_thrd 1"
  #CMD+=" --thrd_per_qp --qps_in_thrd 2 -t 1024"
fi

# TASKSET
if [ $# -eq 5 ]; then
  echo "CORE PINNING ENABLED!"

  END_CORE=$(($4+$5-1))
  echo "Last Core will be $END_CORE"
  echo "MAX_CORE= $MAX_CORE"

  if [ $(($MAX_CORE-1)) -eq $4 ] || [ $END_CORE -eq $4 ]; then
    CMD="$CMD --core_pinning=$4"
  elif [ $END_CORE -ge $(($MAX_CORE-1)) ]; then
    CMD="$CMD --core_pinning=$4-$(($MAX_CORE-1))"
  else
    CMD="$CMD --core_pinning=$4-$END_CORE"
  fi
fi

## TASKSET
#if [ $# -eq 5 ]; then
#  echo "TASKSET ENABLED!"
#
#  END_CORE=$(($4+$5-1))
#  echo "Last Core will be $END_CORE"
#  echo "MAX_CORE= $MAX_CORE"
#
#  if [ $(($MAX_CORE-1)) -eq $4 ] || [ $END_CORE -eq $4 ]; then
#    CMD="taskset -c $4 $CMD"
#  elif [ $END_CORE -ge $(($MAX_CORE-1)) ]; then
#    CMD="taskset -c $4-$(($MAX_CORE-1)) $CMD"
#  else
#    CMD="taskset -c $4-$END_CORE $CMD"
#  fi
#fi

echo $CMD
$CMD & echo $! >> pids

if [ $IS_CLIENT -eq 0 ];then
  sleep 0.3
fi
