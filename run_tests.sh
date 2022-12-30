
# if the variable is defined,
if [ -v LD_LIBRARY_PATH  ];
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



