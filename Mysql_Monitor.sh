#!/bin/bash

#array是一个数组是用来存储Slave_IO_Running和Slave_SQL_Running的值，另外$(cmd)这个是用来执行括号里面cmd的命令的
，而array数组则是用（）扩起来的
array=($(mysql  -uroot -pAdmin@123 -e "show slave status\G"|grep "Running" |awk '{print $2}'))
  if [ "${array[0]}" == "Yes" ] && [ "${array[1]}" == "Yes" ]
    then
      echo slave is OK
    else
      echo slave is error
  fi
