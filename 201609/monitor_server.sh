#!/bin/bash

rm -f "send_file"

#1、获取机器的存储信息
df -h | awk '{info=$1;for(i=2;i<=NF;i++){info=info"\t"$i};print info}' >> "send_file"
echo >> "send_file"

#2、判断是否有休眠的进程(和现在时间差10min 算休眠)
time_interval="10 min"
OLDIFS=$IFS
IFS=$'\n'
have_flag=0
for process_info in `ps aux | grep "hdfs"`
do
    process_time=`echo ${process_info} | awk '{print $9}'`
    process_content=`echo ${process_info} | awk '{content=$11;for(i=12;i<=NF;i++){content=content" "$i};print content}'`
    #进程运行时间
    process_s=`date -d "${process_time}" +%s`
    #现在时间往前捣10分钟
    interval_s=`date -d "-${time_interval}" +%s`
    if [ ${process_s} -lt ${interval_s} ]
    then
        have_flag=1
        echo "${process_content}" >> "send_file"
    fi
done
IFS=$OLDIFS
if [ ${have_flag} -eq 0 ]
then
    echo "==no sleep process==" >> "send_file"
fi
