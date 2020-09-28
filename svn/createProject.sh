#!/bin/bash
# 创建仓库
# 入参：仓库名

if [ ! -n "$1" ] ;then
#    echo "Usage: createProject.sh projectname"
    echo "创建失败，请输入仓库名 createProject.sh projectname"
    exit 2
fi

maindir=/app/svn
domain=168.61.114.20:81

if [ -d "$maindir/$1" ]; then
#  echo "Error: Project "$1" already exsits!"
  echo "创建失败，项目"$1"已存在"
   exit 2
fi

mkdir $maindir/$1
svnadmin create  $maindir/$1
chmod -R o+rw  $maindir/$1
rm -rf  $maindir/$1/conf/authz
rm -rf  $maindir/$1/conf/passwd

svn mkdir http://$domain/$1/trunk -m "init" >/dev/null
svn mkdir http://$domain/$1/branches -m "init">/dev/null
svn mkdir http://$domain/$1/tags -m "init">/dev/null
svn mkdir http://$domain/$1/docs -m "init">/dev/null
cp /app/svn/test/hooks/pre-commit /app/svn/$1/hooks
echo "创建成功！"

#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "mkdir $maindir/$1"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "svnadmin create  $maindir/$1"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "chmod -R o+rw  $maindir/$1"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "rm -rf  $maindir/$1/conf/authz"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "rm -rf  $maindir/$1/conf/passwd"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "cp  $maindir/$1/hooks/pre-revprop-change.tmpl $maindir/$1/hooks/pre-revprop-change"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "echo -e '#!/bin/sh\nexit 0'> $maindir/$1/hooks/pre-revprop-change"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "chmod 755 $maindir/$1/hooks/pre-revprop-change"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "svnsync init file://$maindir/$1 http://$domain/$1"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "echo -e 'svnsync sync file://$maindir/$1 >> $maindir/logs/\`date +%Y-%m-%d\`.log' >> $maindir/sync.sh"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "svnsync sync file://$maindir/$1 >> $maindir/logs/\`date +%Y-%m-%d\`.log"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "cp /app/svn/test/hooks/pre-commit /app/svn/$1/hooks"
#sshpass -p 'Htsc#test@987321' ssh appadmin@168.61.1.106 "echo -e 'svnsync --allow-non-empty init file://$maindir/$1 http://$domain/$1' >> $maindir/bakinit.sh"
