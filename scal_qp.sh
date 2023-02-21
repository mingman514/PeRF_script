source ./config.sh
source ./utils.sh

trap stop_program INT

for (( QP_NUM=1; QP_NUM <= 1024; QP_NUM*=2));
do
  reset_pids

  echo "<<<< QP Num: $QP_NUM >>>>"
  ./script/run_bw.sh write $QP_NUM "" 2 $(($MAX_CORE-1)) &

  echo "***** Press Enter to Start Next *****"
  read input

  kill_nth_process 0
  sleep 0.5

done

echo "TEST DONE."
./kill_ib.sh
