export BASE_DIR=$(pwd)
export SERVER_IP=192.168.0.1
export IS_CLIENT=1
export DEV=mlx5_0

if [ $IS_CLIENT -eq 0 ];then
  unset SERVER_IP
fi
