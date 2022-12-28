# EX) ./run_msg.sh write 3

TYPE=$1
ITER=$2
PORT=9000

sleep 0.3

CMD="$BASE_DIR/bin/ib_${TYPE}_bw -d mlx5_0 -F --run_infinitely -D 2 -l 32 -s 16 -p $PORT $SERVER_IP -q $ITER --report_gbits $3"

if [ "$ITER" -ge 2 ]
then
  CMD+=" --thrd_per_qp"
fi

echo $CMD
$CMD & echo $! >> pids
#sleep 0.3
