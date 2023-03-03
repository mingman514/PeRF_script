# EX) ./run_bw.sh write 3 "~~" start_core_num core_num_needed

#source ./config.sh > /dev/null 2>&1
TYPE=$1
ITER=$2
PORT=9000

if [ $IS_CLIENT -eq 1 ];then
  sleep 0.3
fi

CMD="$BASE_DIR/bin/ib_${TYPE}_bw -d ${DEV} -F --run_infinitely -D 2 -s 1048576 -p $PORT $SERVER_IP -q $ITER --report_gbits"

#if [ "$ITER" -ge 2 ]
#then
#  CMD+=" --thrd_per_qp --qps_in_thrd 2"
#fi

# TASKSET
if [ $# -eq 5 ]; then
  echo "CORE PINNING ENABLED!"

  END_CORE=$(($4+$5-1))
  echo "Last Core will be $END_CORE"
  echo "MAX_CORE= $MAX_CORE"

  if [ $MAX_CORE -eq $4 ] || [ $END_CORE -eq $4 ]; then
    CMD="$CMD --core_pinning=$4"
  elif [ $END_CORE -ge $MAX_CORE ]; then
    CMD="$CMD --core_pinning=$4-$MAX_CORE"
  else
    CMD="$CMD --core_pinning=$4-$END_CORE"
  fi
fi

CMD="$CMD $3"
echo $CMD
$CMD & echo $! >> pids

if [ $IS_CLIENT -eq 0 ];then
  sleep 0.3
fi
