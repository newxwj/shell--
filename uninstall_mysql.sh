#!/bin/bash
#检查数据库是否存在
echo  -e "\033[31;47m  检查数据库是否存在。。。  \033[0m"

echo  -e "1 检查oracle数据库是否存在:  \c"
rpm -qa|grep oracle
if [ $? -eq 0 ]
then
  echo "oracle 已存在，请卸载！"
  exit
else
  echo "oracle 不存在"
fi

echo  -e "2 检查mysql数据库是否存在:  \c"
rpm -qa|grep mysql >>/dev/null
if [ $? -eq 0 ]
then
  echo “mysql已存在，正在卸载。。。”
  ##卸载mysql
  yum -y -q  remove  mysql*
  find / -name mysql -exec rm -rf {} \;
  echo "卸载完成"
else
  echo "mysql 不存在"
fi

echo  -e "3 检查mariadb数据库是否存在:  \c"
rpm -qa|grep mariadb >>/dev/null
if [ $? -eq 0 ]
then
  echo “mariadb已存在，正在卸载。。。”
  ##卸载mariadb
  yum -y -q remove  mariadb*
  find / -name mysql -exec rm -rf {} \;
  echo  “卸载完成”
else
  echo "mariadb 不存在"
fi

