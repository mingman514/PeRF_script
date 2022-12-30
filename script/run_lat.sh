# EX) ./run_lat.sh write

source ./config.sh
TYPE=$1
PORT=9000

if [ $IS_CLIENT -eq 1 ];then
  sleep 0.3
fi

CMD="$BASE_DIR/bin/ib_${TYPE}_lat -d ${DEV} -F -s 16 -n 5000000 -p ${PORT} $SERVER_IP $2"
#CMD="sudo taskset -c 3 $BASE_DIR/bin/ib_${TYPE}_lat -d ${DEV} -F -s 16 -n 5000000 -p ${PORT} $SERVER_IP $2"
echo $CMD
$CMD
#$CMD & echo $! >> /tmp/pids
#sleep 0.3
