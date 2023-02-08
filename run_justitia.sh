source ./config.sh
test_ver=(1 2 3 4 5 6 7 8)


# TOKEN 1500
TOKEN_SIZE=1100
./script/change_token.sh 2200 $TOKEN_SIZE
./script/change_token.sh 9500 $TOKEN_SIZE
./update_bin.sh
./test0-1.sh
for t_num in ${test_ver[@]}
do
  echo "#################################"
  echo "###### START TEST #$t_num #######"
  echo "#################################"
  ./test$t_num.sh
done

if [ $IS_CLIENT -eq 1 ]; then
echo "TEST is DONE." | mail -s "Justitia($TOKEN_SIZE) TEST is done!" mingyu514@g.skku.edu
fi

# TOKEN 5500
sleep 2
TOKEN_SIZE=2200
./script/change_token.sh 1100 $TOKEN_SIZE
./script/change_token.sh 9500 $TOKEN_SIZE
./update_bin.sh

./test0-1.sh
for t_num in ${test_ver[@]}
do
  echo "#################################"
  echo "###### START TEST #$t_num #######"
  echo "#################################"
  ./test$t_num.sh
done

if [ $IS_CLIENT -eq 1 ]; then
echo "TEST is DONE." | mail -s "Justitia($TOKEN_SIZE) TEST is done!" mingyu514@g.skku.edu
fi

# TOKEN 9500
#sleep 2
#TOKEN_SIZE=9500
#./script/change_token.sh 1100 $TOKEN_SIZE
#./script/change_token.sh 2200 $TOKEN_SIZE
#./update_bin.sh
#
#./test0-1.sh
#for t_num in ${test_ver[@]}
#do
#  echo "#################################"
#  echo "###### START TEST #$t_num #######"
#  echo "#################################"
#  ./test$t_num.sh
#done
#
#if [ $IS_CLIENT -eq 1 ]; then
#echo "TEST is DONE." | mail -s "Justitia($TOKEN_SIZE) TEST is done!" mingyu514@g.skku.edu
#fi
