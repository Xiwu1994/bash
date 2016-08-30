#!/bin/bash
#==========conf
#备份文件夹里所有的.sh .py .conf 到新的文件夹里(保存原有的文件目录)
fileType_arr=(sh py conf)
#==========conf

type_length=${#fileType_arr[@]}

function exists_pattern_files(){
    local need_bak_dir=$1
    local file_type=$2
    return `ls ${need_bak_dir} | grep -qE "\.${file_type}$"`
}

function cp_file()
{
    local need_bak_dir=$1
    local bak_dir=$2
    for((i=0;i<${type_length};i++))
    do
        file_type=${fileType_arr[$i]}
        exists_pattern_files ${need_bak_dir} ${file_type} && {
            mkdir -p ${bak_dir}
            cp "${need_bak_dir}/"*.${file_type} ${bak_dir}
        }
    done
}

function bak()
{
    local need_bak_dir=$1
    local bak_dir=$2
    cp_file ${need_bak_dir} ${bak_dir}
    for file in `ls ${need_bak_dir}`
    do
        local path="${need_bak_dir}/${file}"
        local bak_path="${bak_dir}/${file}"
    	if [ -d $path ]
    	then
        	bak ${path} ${bak_path}
    	fi
    done
}

bak "/data" "/tmp/bak"
