CUR=$(pwd)
cp ../perf/perftest-multhrd/ib_* $CUR/bin

pkill pacer
cd ../Justitia/rdma_pacer
make clean && make
cp pacer $CUR/bin
