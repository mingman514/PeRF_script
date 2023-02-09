source ./config.sh
test_ver=(1 2 3 4 5 6 7 8 9)


./update_bin.sh
for t_num in ${test_ver[@]}
do
  echo "#################################"
  echo "###### START TEST #$t_num #######"
  echo "#################################"
  ./test$t_num.sh
done

if [ $IS_CLIENT -eq 1 ]; then
echo "TEST is DONE." | mail -s "TEST Mode #$MODE is done!" mingyu514@g.skku.edu
fi
