stop_program(){
  kill_all 
  exit 0
}

rename_log_folder(){
  timestamp=`date +%Y%m%d%H%M`

  mv $1 $1/../$2_$timestamp
  echo "log folder: $2_$timestamp"
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
