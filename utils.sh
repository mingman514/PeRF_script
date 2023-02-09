stop_program(){
  kill_all 
  sudo pkill pacer
  sudo pkill perf_main
  exit 0
}

rename_log_folder(){
  timestamp=`date +%Y%m%d%H%M`

  mv $1 $1/../$2_$timestamp
  echo "log folder: $2_$timestamp"

  sudo pkill pacer
  sudo pkill perf_main
}


reset_pids() {
  echo "rm pids && touch pids"
  sudo rm pids
  touch pids
}

kill_all() {
  PIDS=$(cat pids | cut -d " " -f2)
  echo -e "Kill all:\n${PIDS[*]}"
  for p in ${PIDS[@]}
  do
    sudo kill -TERM $p 2> /dev/null
  done  
  sleep 2
}

kill_process() {
  echo "Kill $1"
}

kill_nth_process(){
  arr=()

  PIDS=$(cat pids | cut -d " " -f2)
  for p in ${PIDS[@]}
  do
    arr+=("$p")
  done
  sudo kill -TERM ${arr["$1"]}
}

run_pacer() {

  if [ -v LD_LIBRARY_PATH ]; then
    # JUSTITIA
    echo "<< Justitia Mode Enabled >>"
    PID=$(pidof pacer)
    if [ -n "$PID" ]; then
      echo Kill current pacer.
      sudo pkill pacer
    fi

    echo "@@@@ run pacer! (PID: $PID)"
    LD_LIBRARY_PATH="" taskset -c 0 ../Justitia/rdma_pacer/pacer $IS_CLIENT $SERV_IP 1 5 &
    sleep 3 

  elif [[ $PERF_ENABLE -eq 1 ]]; then
    # PERF
     echo "<< PERF Mode Enabled >>"
     sudo rm /dev/shm/perf-shm
    PID=$(pidof perf_main)
    if [ -n "$PID" ]; then
      echo Kill current perf_main.
      sudo pkill perf_main
    fi

    echo "@@@@ run perf_main! (PID: $PID)"
    PERF_NIC_LINK_BW=100000 PERF_NIC_MSG_RATE=12400  PERF_NIC_QPS_CAPA=9 taskset -c 0 ./bin/perf_main &
    sleep 3
   
  fi
}
