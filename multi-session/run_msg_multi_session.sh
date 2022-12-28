# EX) ./run_msg.sh write 3

TYPE=$1
ITER=$2
PORT=9000

i=0
while [ $i -lt $ITER ]
do
  sleep 0.3

  CMD="ib_${TYPE}_bw -d mlx5_0 -F -S 3 --run_infinitely -D 2 -l 16 -s 8 -p $(($PORT + $i)) 192.168.0.1 --report_gbits $3"
  #CMD="ib_${TYPE}_bw -d mlx5_0 -F --run_infinitely -D 2 -l 32 -s 16 -p $(($PORT + $i)) 192.168.0.1 --report_gbits $3"
  echo $CMD
  $CMD &
  #sleep 0.3

  i=$(($i+1))
done

sleep 100
echo kill ib_"$TYPE"_bw
pkill ib_"$TYPE"_bw
