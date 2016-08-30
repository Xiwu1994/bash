#!/bin/bash

#===CONF===
Nproc=5 #可同时运行最大作业数


Pfifo="/tmp/$$.fifo" #以PID为名(防重复)
mkfifo ${Pfifo} #创建命名管道
exec 6<>${Pfifo} #读写方式打开，文件标识符fd为6
rm -f ${Pfifo}

for((i=1;i<=${Nproc};i++))
do
    echo #命名管道里存6个空行
done >&6

while true;do
    read -u6 { #读取一行，命名管道少一行(如果读不了，说明当时并发数已经到顶，进程阻塞)  相当P操作
        Run Job #=======运行任务=========
        sleep 1 #给系统缓冲时间，必须要
        echo >&6 #向命名管道写入一行  相当V操作
    } & #启动子进程放在后台运行
done

wait #等待所有后台子进程结束
exec 6>&- #删除文件标识符

#转自http://www.linuxidc.com/Linux/2015-01/112363.htm