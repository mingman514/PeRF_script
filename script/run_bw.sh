# EX) ./run_bw.sh write 3

source ./config.sh
TYPE=$1
ITER=$2
PORT=9000

if [ $IS_CLIENT -eq 1 ];then
  sleep 0.3
fi

CMD="$BASE_DIR/bin/ib_${TYPE}_bw -d ${DEV} -F --run_infinitely -D 2 -s 1048576 -p $PORT $SERVER_IP -q $ITER --report_gbits $3"

if [ "$ITER" -ge 2 ]
then
  CMD+=" --thrd_per_qp"
fi

echo $CMD
$CMD & echo $! >> pids

if [ $IS_CLIENT -eq 0 ];then
  sleep 0.3
fi
