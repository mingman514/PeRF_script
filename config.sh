export BASE_DIR=$(pwd)
export LAT_TEST_ITER=10
export SERVER_IP=10.0.103.2
export IS_CLIENT=1
export DEV=mlx5_0

SERV_IP=$SERVER_IP  # For justitia pacer

if [ $IS_CLIENT -eq 0 ];then
  unset SERVER_IP
fi
