FROM=$1
TO=$2

CUR_PWD=$(pwd)
cd ../perf/Justitia/rdma_pacer

CMD="s/#define DEFAULT_BATCH_OPS $1/#define DEFAULT_BATCH_OPS $2/g"
#echo "sed -i \"$CMD\" pacer.c"
sed -i "$CMD" pacer.c
echo "<<< TOKEN is changed from $1 to $2 >>>"

cd $CUR_PWD
