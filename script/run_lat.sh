# EX) ./run_lat.sh write

#source ./config.sh > /dev/null 2>&1
TYPE=$1
PORT=9000

if [ $IS_CLIENT -eq 1 ];then
  sleep 0.3
fi

CMD="$BASE_DIR/bin/ib_${TYPE}_lat -d ${DEV} -F -s 16 -n 10000000 -p ${PORT} $SERVER_IP"

# TASKSET
if [ $# -eq 3 ]; then
  echo "CORE PINNING ENABLED!"
  CMD="taskset -c $3 $CMD"
elif [ $# -gt 3 ]; then
  echo "Too many arguments!"
  exit 1
fi

CMD="$CMD $2"
echo $CMD
$CMD
#$CMD & echo $! >> /tmp/pids
#sleep 0.3
