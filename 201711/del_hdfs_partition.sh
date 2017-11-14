#!/bin/bash
IFS=$'\n'

hdfs_home="/user/hive/warehouse"
del_day_count=30
del_p_day_timestamp=`date -d"- ${del_day_count} days" +%s`

function is_dir()
{
    local hdfs_path=$1
    return `echo ${hdfs_path} | grep -qE "^d"`
}

function is_p_day_partition()
{
    local hdfs_path=$1
    return `echo ${hdfs_path} | grep -qE "(p_day=)|(the_day=)"`
}

function del_partition()
{
    local hdfs_path=$1
    hdfs dfs -rm -r ${hdfs_path}
    hdfs dfs -rm -r "/user/root/.Trash/Current"${hdfs_path}
    #echo "del_path: "${hdfs_path}
}

function process_partition()
{
    local hdfs_info=$1
    local p_day=`echo ${hdfs_info} | awk 'BEGIN{FS="="}{print $NF}'`

    
    local p_day_timestamp=`date -d"${p_day}" +%s`


    if [ ${p_day_timestamp} -lt ${del_p_day_timestamp} ]
    then
        local hdfs_path=`echo ${hdfs_info} | awk '{print $NF}'`
        del_partition ${hdfs_path}
    fi
}

function process()
{
    local hdfs_path=$1
    
    for file_info in `hdfs dfs -ls ${hdfs_path}`
    do
        is_dir ${file_info} && {
            is_p_day_partition ${file_info} && {
                process_partition ${file_info}
            } || {
                local next_hdfs_path=`echo ${file_info} | awk '{print $NF}'`
                process ${next_hdfs_path}
            }
        }
    done
}

process ${hdfs_home}
