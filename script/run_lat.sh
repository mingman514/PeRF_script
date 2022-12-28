# EX) ./run_lat.sh write

TYPE=$1
PORT=9000

sleep 0.3

CMD="sudo taskset -c 3 $BASE_DIR/bin/ib_${TYPE}_lat -d mlx5_0 -F -s 16 -n 5000000 -p ${PORT} $SERVER_IP $2"
echo $CMD
$CMD
#$CMD & echo $! >> /tmp/pids
#sleep 0.3
