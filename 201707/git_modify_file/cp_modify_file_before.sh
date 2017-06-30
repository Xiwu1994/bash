#!/bin/bash

#
# 将git modifyed 的代码备份到 当前目录下
#

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #当前工作目录
bak_time=`date +%F` #备份日期

cd /home/hadoop/etl_project/beeper_data_warehouse

#1. 先建对应的目录
git status | grep modified | awk '{print $NF}' | awk -v work_dir="${WORK_DIR}" -v bak_time=${bak_time} -F "/" '
{
  line=$1
  for(i=2;i<NF;i++){
    line=line"/"$i
  }
  if(NF==1){next}
  system("mkdir -p "work_dir"/"bak_time"/"line)
}'

#2. cp文件到对应的目录
git status | grep modified | awk -v work_dir="${WORK_DIR}" -v bak_time=${bak_time} '
{
  dir_path_file=""
  len = split($NF, arr, "/")
  for(i=1;i<len;i++){
    if(i==1){
      dir_path_file=arr[i]
    }else{
      dir_path_file=dir_path_file"/"arr[i]
    }
  }
  system("cp "$NF" "work_dir"/"bak_time"/"dir_path_file)
}' 

#3. checkout 修改的文件
git status | grep modified | awk '{print $NF}' | xargs git checkout -- 
