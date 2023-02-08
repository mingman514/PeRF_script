source ./config.sh
# if the variable is defined,
if [ $MODE -gt 0 ];
then
  # For Justitia
  echo "TEST START: Justitia/PERF version"
  ./test0-1.sh
  for ((var=1; var<=8; var++))
  do
    echo "TEST #$var START"
    ./test$var.sh
  done

else
  # For Default App
  echo "TEST START: Default version"
  for ((var=0; var<=8; var++))
  do
    echo "TEST #$var START"
    ./test$var.sh
  done
fi

if [ $IS_CLIENT -eq 1 ]; then
  if [ $MODE -eq 0 ]; then
    TEST_T="DEFAULT"
  elif [ $MODE -eq 1 ]; then
    TEST_T="JUSTITIA"
  elif [ $MODE -eq 2 ]; then
    TEST_T="PERF"
  fi 
  echo "$TEST_t TEST is DONE." | mail -s "$TEST_T TEST is done!" mingyu514@g.skku.edu
fi
