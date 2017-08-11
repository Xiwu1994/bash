#!/bin/bash
# reset
rm -rf "data/date_res/*"

HDFS_CMD="hdfs dfs -ls"
parent_dir="/user/hive/warehouse"

function process()
{
    local path=$1
    ${HDFS_CMD} ${path} | grep -v "Found" > "data/path/${path//\//#}"
    while read line
    do
        if [ ${line:0:1} == "d" ]
        then
            child_path=`echo ${line} | awk '{print $NF}'`
            echo ${child_path}
            process ${child_path}
        else
            update_date=`echo ${line} | awk '{print $6}'`
            echo ${line} >> "data/date_res/${update_date}"
        fi
    done < "data/path/${path//\//#}"
}

process ${parent_dir}