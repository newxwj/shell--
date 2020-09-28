#!/bin/bash
## 修改/app/svn/conf/authz  添加用户权限
## 入参：账号(K1580001,K1580002)  仓库名(test)  读写(rw/r)  子目录(abc/def) 
## 流程：
## 1 判断参数个数是否小于3个，判断仓库是否存在
## 2 判断authz是否存在 [仓库:/子目录]，如不存在添加;  如存在，判断权限是否已存在，不存在则添加
if [ $# -lt 3 ] ;then
    echo "Error: Number of parameters is not right"
    exit 2
fi

maindir=/app/svn

if [ ! -d "$maindir/$2" ]; then
  echo "Error: Project "$2" is not  exsits!"
  exit 2
fi


#仓库repository  
#不带子目录 示例：[test:/]
repository="["$2":/]" 

#带子目录 示例：[test:/abc/def]
if [ -n "$4" ] ;then
   repository="["$2":/"$4"]"
fi



#组名 user_rw   user_r
user_rw=$2"_rw"
user_r=$2"_r"
user=$2"_"$3

if [ -n "$4" ] ;then
    string=`echo $4 | sed -e "s/\//_/g"`
   # string=`echo $string1 | sed -e "s/-/_/g"`
    user_rw=$2"_"$string"_rw"
    user_r=$2"_"$string"_r"
    user=$2"_"$string"_"$3
fi

name=$1

groups(){

       #如果权限存在  test =K1580001
        #grep -E  '$user\ {0,1}=' authz |grep $1>>/dev/null
        grep -E  "^$user\ {0,1}=" /app/svn/conf/authz |grep $name  >>/dev/null 
        if [ $? -eq 0 ];then
            echo "权限已存在"
            exit 2
        fi
        
         #如果权限不存在存在test =K1580001
        grep -E  "^$user\ {0,1}=" /app/svn/conf/authz | grep "[0-9a-zA-Z]$" >>/dev/null
        if [  $? -eq 0 ];then
            num=`grep -E -n  "^$user\ {0,1}=" /app/svn/conf/authz |awk -F ':' '{print $1}'`
            sed -i "$num s/$/&\,$name/" /app/svn/conf/authz
            echo "执行成功,添加,账号"
            exit 2
        fi       


        #如果存在test=
        #如果权限不存在存在test =K1580001
        grep -E  "^$user\ {0,1}=" /app/svn/conf/authz | grep "=$" >>/dev/null
        if [  $? -eq 0 ];then
            num=`grep -E -n  "^$user\ {0,1}=" /app/svn/conf/authz |awk -F ':' '{print $1}'`
            sed -i "$num s/$/&$name/" /app/svn/conf/authz
            echo  "执行成功,添加账号 账号"
            exit 2
        fi
        

}



#判断如果authz中如果不存在仓库目录[test:/];
grep -F "$repository"  /app/svn/conf/authz>/dev/null
if [ ! $? -eq 0 ] ;then
#文件末尾添加目录权限设置
   echo $repository >> /app/svn/conf/authz
   echo "@qaadmin=rw">>/app/svn/conf/authz
   echo "@zlcft_qa=r">>/app/svn/conf/authz
   echo  "@$user=$3">>/app/svn/conf/authz
   echo >>/app/svn/conf/authz  

#添加用户，组
   sed -i "/\[\/\]/i$user=$name" /app/svn/conf/authz
       echo  "执行成功"
       exit 2
   
fi


#判断如果authz中存在此仓库目录[test:/]，但不存在@test_rw
if ( grep -F "$repository"  /app/svn/conf/authz>/dev/null ) && ( ! grep -F "@$user="  /app/svn/conf/authz>/dev/null )
then
    num=`grep -F -n "$repository"  /app/svn/conf/authz|awk  -F ':' '{print $1}'` 
#   echo $num
    sed -i "$num a\@$user=$3" /app/svn/conf/authz
    sed -i "/\[\/\]/i$user=$name" /app/svn/conf/authz
    echo  "执行成功"
     exit 2
fi


#为组添加用户
groups
