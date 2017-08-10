#!/bin/bash
yesterday=`date -d -1day +%F`

####需要修改的配置####
table_1="dwa_beeper.dwa_beeper_customer_task_p_day"
table_2="decoupling_dwa_beeper.dwa_beeper_customer_task_p_day"
join_key="customer_id"
is_partition_table=1
#######################

if [ ${is_partition_table} -eq 0 ]
then
  hsql='set hivevar:yesterday="'${yesterday}'";
  set mapreduce.reduce.memory.mb=4096;
  set mapreduce.reduce.java.opts=-Xmx4096m;
  set yarn.app.mapreduce.am.resource.mb=2048;
  set mapreduce.map.memory.mb=3072;
  select t1.*, t2.*
  from '${table_1}' t1
  left join '${table_2}' t2
  on t1.'${join_key}' = t2.'${join_key}'
  where
  hash(t1.*)
  <>
  hash(t2.*) limit 100'
else
  hsql='set hivevar:yesterday="'${yesterday}'";
  set mapreduce.reduce.memory.mb=4096;
  set mapreduce.reduce.java.opts=-Xmx4096m;
  set yarn.app.mapreduce.am.resource.mb=2048;
  set mapreduce.map.memory.mb=3072;
  select t1.*, t2.*
  from '${table_1}' t1
  left join '${table_2}' t2
  on t1.'${join_key}' = t2.'${join_key}' and t2.p_day=${yesterday}
  where t1.p_day=${yesterday} and
  hash(t1.*)
  <>
  hash(t2.*) limit 100'
fi

echo $hsql

#run_hsql
hive -e "${hsql}" > data
