#!/bin/bash

## 参数 ##
begin_date='2018-10-01'
end_date='2018-11-03'


run_date=${begin_date}

while [ `date -d "${run_date}" +%s` -le `date -d "${end_date}" +%s` ]
do
   echo ${run_date}
   
   # 运行入口
   hive -hivevar dtPartition=${run_date} -f script.sql

   run_date=`date -d "${run_date} +1 day" +%F`
done
