#!/bin/bash

# 获取/app磁盘信息
# app_all /app磁盘大小     app_used /app 已使用磁盘大小   app_percent /app磁盘使用率 
app_all=$(df -lh | grep -w '\/app' | awk '{print $2}')
app_used=$(df -lh | grep -w '\/app' | awk '{print $3}')
app_percent=$(df -lh | grep -w '\/app' | awk '{print $5}')
echo "app目录磁盘空间总大小： $app_all"
echo "app目录已使用磁盘空间： $app_used"
echo "app目录磁盘空间使用率： $app_percent"

# 获取服务器内存信息
mem_total=$(free -h| awk 'NR==2 {print $2}') #内存大小
mem_used=$(free -h| awk 'NR==2 {print $3}')   #已使用内存
mem_free=$(free -h| awk 'NR==2 {print $4}')  #剩余内存
mem_total1=$(free | awk 'NR==2 {print $2}')  #内存大小 数字格式
mem_used1=$(free | awk 'NR==2 {print $3}')  #已使用内存 数字格式
mem_percent=$(printf "%d%%" $((mem_used1*100/mem_total1)))
echo "内存总大小：$mem_total"
echo "已使用内存： $mem_used"
echo "剩余内存： $mem_free"
echo "内存使用率：$mem_percent"

#获取CPU使用率
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
CPU_USAGE=`echo ${SYSTEM_IDLE} ${TOTAL_TIME} | awk '{printf "%.2f", 100-$1/$2*100}'`

echo "CPU Usage:${CPU_USAGE}%"

#获取CPU负载信息
# top -n 参数指定运行次数，1代表运行一次即停止，不再等待top数据更新，使用awk指定分割符，提取数据
cpu_load1=`top -b -n 1|awk 'NR==1{print $12}'`
cpu_load5=`top -b -n 1|awk 'NR==1{print $13}'`
cpu_load15=`top -b -n 1|awk 'NR==1{print $14}'`
echo "$now 当前cpu 1分钟、5分钟、15分钟的负载分别为 $cpu_load1 $cpu_load5 $cpu_load15"
#获取CPU核数  /proc/cpuinfo 需要root才可以查看
#cpu_phy=cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
#每颗物理CPU的核数
#cpu_cores=cat /proc/cpuinfo| grep "cpu cores"| uniq
#cpu总核数
#cpu_num=$((cpu_phy*cpu_cores))
echo  "建议负载大于CPU核数报警"
