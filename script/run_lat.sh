# EX) ./run_lat.sh write

#source ./config.sh > /dev/null 2>&1
TYPE=$1
PORT=9000

if [ $IS_CLIENT -eq 1 ];then
  sleep 0.3
fi

CMD="$BASE_DIR/bin/ib_${TYPE}_lat -d ${DEV} -F -s 16 -n 10000000 -p ${PORT} $SERVER_IP"

# TASKSET
if [ $# -eq 4 ]; then
  echo "CORE PINNING ENABLED!"

  END_CORE=$(($3+$4-1))
  echo "Last Core will be $END_CORE"
  echo "MAX_CORE= $MAX_CORE"

  if [ $MAX_CORE -eq $3 ] || [ $END_CORE -eq $3 ]; then
    CMD="$CMD --core_pinning=$3"
  elif [ $END_CORE -ge $MAX_CORE ]; then
    CMD="$CMD --core_pinning=$3-$MAX_CORE"
  else
    CMD="$CMD --core_pinning=$3-$END_CORE"
  fi
fi

CMD="$CMD $2"
echo $CMD
$CMD
#$CMD & echo $! >> /tmp/pids
#sleep 0.3
