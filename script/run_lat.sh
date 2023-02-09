# EX) ./run_lat.sh write

source ./config.sh > /dev/null 2>&1
TYPE=$1
PORT=9000

if [ $IS_CLIENT -eq 1 ];then
  sleep 0.3
fi

CMD="$BASE_DIR/bin/ib_${TYPE}_lat -d ${DEV} -F -s 16 -n 10000000 -p ${PORT} $SERVER_IP $2"

# TASKSET
if [ $# -eq 4 ]; then
  echo "CORE PINNING ENABLED!"

  END_CORE=$(($3+$4-1))
  echo "Last Core will be $END_CORE"
  echo "MAX_CORE= $MAX_CORE"

  if [ $(($MAX_CORE-1)) -eq $3 ] || [ $END_CORE -eq $3 ]; then
    CMD="$CMD --core_pinning=$3"
  elif [ $END_CORE -ge $(($MAX_CORE-1)) ]; then
    CMD="$CMD --core_pinning=$3-$(($MAX_CORE-1))"
  else
    CMD="$CMD --core_pinning=$3-$END_CORE"
  fi
fi

## TASKSET
#if [ $# -eq 4 ]; then
#  echo "TASKSET ENABLED!"
#
#  END_CORE=$(($3+$4-1))
#  echo "Last Core will be $END_CORE"
#  echo "MAX_CORE= $MAX_CORE"
#
#  if [ $(($MAX_CORE-1)) -eq $3 ] || [ $END_CORE -eq $3 ]; then
#    CMD="taskset -c $3 $CMD"
#  elif [ $END_CORE -ge $(($MAX_CORE-1)) ]; then
#    CMD="taskset -c $3-$(($MAX_CORE-1)) $CMD"
#  else
#    CMD="taskset -c $3-$END_CORE $CMD"
#  fi
#fi


echo $CMD
$CMD
#$CMD & echo $! >> /tmp/pids
#sleep 0.3
