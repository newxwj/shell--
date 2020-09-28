#!/bin/bash
## 查找authz中，哪些用户对此仓库用rw权限
## 入参： 仓库名
if [ ! -n "$1" ] ;then
    echo "Usage: inqury.sh projectname"
    exit 2
fi


maindir=/app/svn
if [ ! -d "$maindir/$1" ]; then
  echo "Error: Project "$1" already exsits!"
  exit 2
fi

string="["$1":/]"
#grep -F -w "$string"  /app/svn/conf/authz>/dev/null
#if [ ! $? -eq 0 ];then
#   echo "没有用户对此仓库拥有可读权限，请申请权限"
#   exit 2
#fi

##这些特殊仓库由指定的用户同意 汪海林011002 
case $1 in
"Xops"|"ATS-Platform"|"ATS-Business"|"XMemDB"|"DataLoader"|"DataCenter"|"ATS-Quant"|"ATS-Algo"|"Xinformation"|"usercenter"|"pbcts"|"instruction"|"APIAccess")
echo "011002"
exit
;;
*)
;;
esac
