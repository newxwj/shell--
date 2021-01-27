#!/bin/bash

# 获取/app磁盘信息
# app_total /app磁盘大小     app_used /app 已使用磁盘大小   app_used_percent /app磁盘使用率 
app_total=$(df -lh | grep -w '\/app' | awk '{print $(NF-4)}')
app_used=$(df -lh | grep -w '\/app' | awk '{print $(NF-3)}')
app_used_percent=$(df -lh | grep -w '\/app' | awk '{print $(NF-1)}')
echo "app目录磁盘空间总大小： $app_total"
echo "app目录已使用磁盘空间： $app_used"
echo "app目录磁盘空间使用率： $app_used_percent"


#获取根/的磁盘信息
# 获取/磁盘信息
# root_total /p磁盘大小     root_used / 已使用磁盘大小   root_used_percent /磁盘使用率 
root_total=$(df -lh | grep -w '\/' | awk '{print $(NF-4)}')
root_used=$(df -lh | grep -w '\/' | awk '{print $(NF-3)}')
root_used_percent=$(df -lh | grep -w '\/' | awk '{print $(NF-1)}')
echo "根目录磁盘空间总大小： $root_total"
echo "根目录已使用磁盘空间： $root_used"
echo "根目录磁盘空间使用率： $root_used_percent"

# 获取服务器内存信息
mem_total=$(free -h| awk 'NR==2 {print $2}') #内存大小
mem_used=$(free -h| awk 'NR==2 {print $3}')   #已使用内存
mem_free=$(free -h| awk 'NR==2 {print $4}')  #剩余内存
mem_total1=$(free | awk 'NR==2 {print $2}')  #内存大小 数字格式
mem_used1=$(free | awk 'NR==2 {print $3}')  #已使用内存 数字格式
mem_used_percent=$(printf "%d%%" $((mem_used1*100/mem_total1)))
echo "内存总大小：$mem_total"
echo "已使用内存： $mem_used"
echo "剩余内存： $mem_free"
echo "内存使用率：$mem_used_percent"

#获取CPU使用率  每5s计算一次
#脚本功能描述：依据/proc/stat文件获取并计算CPU使用率
#
#CPU时间计算公式：CPU_TIME=user+system+nice+idle+iowait+irq+softirq
#CPU使用率计算公式：cpu_usage=(idle2-idle1)/(cpu2-cpu1)*100
#默认时间间隔
TIME_INTERVAL=5
time=$(date "+%Y-%m-%d %H:%M:%S")
LAST_CPU_INFO=$(cat /proc/stat | grep -w cpu | awk '{print $2,$3,$4,$5,$6,$7,$8}')
LAST_SYS_IDLE=$(echo $LAST_CPU_INFO | awk '{print $4}')
LAST_TOTAL_CPU_T=$(echo $LAST_CPU_INFO | awk '{print $1+$2+$3+$4+$5+$6+$7}')
sleep ${TIME_INTERVAL}
NEXT_CPU_INFO=$(cat /proc/stat | grep -w cpu | awk '{print $2,$3,$4,$5,$6,$7,$8}')
NEXT_SYS_IDLE=$(echo $NEXT_CPU_INFO | awk '{print $4}')
NEXT_TOTAL_CPU_T=$(echo $NEXT_CPU_INFO | awk '{print $1+$2+$3+$4+$5+$6+$7}')

#系统空闲时间
SYSTEM_IDLE=`echo ${NEXT_SYS_IDLE} ${LAST_SYS_IDLE} | awk '{print $1-$2}'`
#CPU总时间
TOTAL_TIME=`echo ${NEXT_TOTAL_CPU_T} ${LAST_TOTAL_CPU_T} | awk '{print $1-$2}'`
cpu_used_percent=`echo ${SYSTEM_IDLE} ${TOTAL_TIME} | awk '{printf "%.2f", 100-$1/$2*100}'`

echo "CPU Usage:${cpu_used_percent}%"

#获取CPU核数  /proc/cpuinfo
cpu_phy=`cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`
#每颗物理CPU的核数
cpu_cores=`cat /proc/cpuinfo| grep "cpu cores"| uniq | awk  '{print $4}'`
#cpu总核数
cpu_num=$[$cpu_phy*$cpu_cores]
echo "CPU 核数：$cpu_num"

#获取CPU负载信息
# uptime使用awk指定分割符，提取数据
cpu_load1=`uptime|awk '{print $10}'|tr -d ","`
cpu_load5=`uptime|awk '{print $11}'|tr -d ","`
cpu_load15=`uptime|awk '{print $12}'`
echo "$now 当前cpu 1分钟、5分钟、15分钟的负载分别为 $cpu_load1 $cpu_load5 $cpu_load15"

#获取ip地址
ip=`ifconfig |grep "inet"|grep -v "127.0.0.1"|awk '{print $2}'|tr -d "addr:"`
echo "ip地址： $ip"

#获取网络traffic 每30s计算一次
#采集算法：读取/proc/net/dev文件，得到30秒内发送和接收的字节数,再除以30
network_name=`ifconfig |grep "Link"|grep -v "lo"|awk '{print $1}'`
traffic_be_in=`cat /proc/net/dev |grep "$network_name"|awk '{print $2}'`
traffic_be_out=`cat /proc/net/dev |grep "$network_name"|awk '{print $10}'`
sleep 30
traffic_af_in=`cat /proc/net/dev |grep "$network_name"|awk '{print $2}'`
traffic_af_out=`cat /proc/net/dev |grep "$network_name"|awk '{print $10}'`
eth_in_30s=$(($((traffic_af_in-traffic_be_in))/1024))"kb"
eth_out_30s=$(($((traffic_af_out-traffic_be_out))/1024))"kb"
echo "30秒接收的数据量：$eth_in_30s "
echo "30秒发送的数据量：$eth_out_30s "

#获取磁盘I/O
#采集算法 iostat,此命令计算的是某个磁盘的I/O
#查看磁盘挂载情况 lsblk, 这里我们发现大部分都是挂载到sda磁盘上，所以我们只计算sda的I/O
kb_read=`iostat -dxm|grep sda |awk '{print $6}'`"MB"
kb_wrtn=`iostat -dxm|grep sda |awk '{print $7}'`"MB"
await=`iostat -dxm|grep sda |awk '{print $10}'`"ms"
util=`iostat -dxm|grep sda |awk '{print $14}'`"%"
echo "每秒读数据量: $kb_read "
echo "每秒写数据量: $kb_wrtn "
echo "平均每次IO请求等待时间(包括等待时间和处理时间，毫秒为单位) $await"
echo "IO饱和度： $util"

##写入数据到表中
#TABLE=`echo ${ip//./_}`
#echo $TABLE
TIME=`date +"%Y-%m-%d %H:%M:%S"`
INSERT="insert into monitor.$TABLE" 
FIELD="ip,app_total,app_used,app_used_percent,root_total,root_used,root_used_percent,mem_total,mem_used,mem_free,mem_used_percent,cpu_used_percent,cpu_num,cpu_load1,cpu_load5,cpu_load15,eth_in_30s,eth_out_30s,kb_read,kb_wrtn,await,util,date"

VALUE="'${ip}','${app_total}','${app_used}','${app_used_percent}','${root_total}','${root_used}','${root_used_percent}','${mem_total}','${mem_used}','${mem_free}','${mem_used_percent}','${cpu_used_percent}',${cpu_num},'${cpu_load1}','${cpu_load5}','${cpu_load15}','${eth_in_30s}','${eth_out_30s}','${kb_read}','${kb_wrtn}','${await}','${util}','${TIME}'"
echo $FIELD
echo $VALUE

mysql -h168.63.118.96 -uroot -pHtsc@JiraTest223 -e "use  monitor;insert into serverInfo (${FIELD}) values (${VALUE})";




