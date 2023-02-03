export BASE_DIR=$(pwd)
export LAT_TEST_ITER=10
export SERVER_IP=10.0.103.2
export IS_CLIENT=1
#export IS_CLIENT=0
export DEV=mlx5_0
export MODE=0 # Default: 0  Justitia: 1  PERF: 2



# TASKSET
export MAX_CORE=16
export CORE_START=0
if [ $MODE -gt 0 ]; then
  export CORE_START=1
fi



# Environment Variables
unset LD_LIBRARY_PATH
unset \
    PERF_ENABLE PERF_CHUNK_SIZE PERF_DUMMY_FACTOR \
    DUMMY_FACTOR_2 PERF_READ_PORT  PERF_IB_PORT \
    PERF_GIDX TB_TARGET_RATE PERF_IS_SERVER

if [ $MODE -eq 1 ]; then
  # Justitia
  export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
  echo "<<<<<< JUSTITIA ENV >>>>>>"
  echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

elif [ $MODE -eq 2 ]; then
  # PERF
  export \
    PERF_ENABLE=1 \
    PERF_CHUNK_SIZE=16384 \
    PERF_DUMMY_FACTOR=1024 \
    DUMMY_FACTOR_2=0 \
    PERF_READ_PORT=2111 \
    PERF_IB_PORT=1 \
    PERF_GIDX=5 \
    TB_TARGET_RATE=0

  if [ $IS_CLIENT -eq 1 ]; then
    export PERF_IS_SERVER=0
  else
    export PERF_IS_SERVER=1
  fi
  echo "<<<<<< PERF ENV >>>>>>"
  echo \
    "PERF_ENABLE=$PERF_ENABLE \
    PERF_CHUNK_SIZE=$PERF_CHUNK_SIZE \
    PERF_DUMMY_FACTOR=$PERF_DUMMY_FACTOR \
    DUMMY_FACTOR_2=$DUMMY_FACTOR_2 \
    PERF_READ_PORT=$PERF_READ_PORT \
    PERF_IB_PORT=$PERF_IB_PORT \
    PERF_GIDX=$PERF_GIDX \
    TB_TARGET_RATE=$TB_TARGET_RATE"
else
  echo "DEFAULT MODE: Unset variables"
fi
sleep 1


# SERVER-CLIENT
SERV_IP=$SERVER_IP  # For justitia pacer

if [ $IS_CLIENT -eq 0 ];then
  unset SERVER_IP
fi
