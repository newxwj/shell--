#!/bin/bash
## nginx启动脚本
nginx_path=/usr/local/nginx
start()
{
  if [ -f $nginx_path/logs/nginx.pid ]
  then
     echo "nginx 已处于运行状态，无需启动"
  else
     $nginx_path/sbin/nginx
     echo "nginx 启动成功"
  fi
}

stop()
{
  if [ ! -f $nginx_path/logs/nginx.pid ]
  then
     echo "nginx 已处于停止状态，无需停止"
  else
     $nginx_path/sbin/nginx -s stop
     echo "nginx 停止成功"
  fi
}

status()
{
  if [ -f $nginx_path/logs/nginx.pid ]
  then
     echo "nginx 处于运行状态"
  else
     echo "nginx 处于停止状态"
  fi
}



case $1 in
start)
   start
;;
stop)
   stop
;;
status)
   status
;;
restart)
   stop
   sleep 1
   start
;;
esac
