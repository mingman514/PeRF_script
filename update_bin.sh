source ./config.sh

CUR=$(pwd)
#cp ../perf/perftest-multhrd/ib_* $CUR/bin
cd ../perf/perftest-4.5.0-multhrd
./build.sh
cp ./ib_* $CUR/bin

if [ $MODE -eq 1 ]; then
pkill pacer
  cd $CUR/../Justitia/rdma_pacer
  make clean && make
  cp pacer $CUR/bin
fi

if [ $MODE -eq 2 ]; then
  pkill perf_main
  cd $CUR/../perf/perf_src
  gcc perf_main.c -o perf_main -lpthread -lrt
  cp perf_main $CUR/bin
fi

cd $CUR
