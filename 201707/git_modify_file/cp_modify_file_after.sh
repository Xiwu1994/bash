#!/bin/bash

#就备份的文件 cp 到git工程中

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #当前工作目录
bak_time=`date +%F` #备份日期

des_path="/home/hadoop/etl_project/beeper_data_warehouse"


cd ${WORK_DIR}/${bak_time}
#cp文件到对应的目录
function read_dir(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]  #注意此处之间一定要加上空格，否则会报错
        then
            read_dir $1"/"$file
        else
            cp $1"/"$file ${des_path}"/"$1
        fi
    done
}

read_dir "."
