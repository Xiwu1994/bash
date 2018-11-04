insert overwrite table tmp.table partition (dt='${dtPartition}')
  select
    '${dtPartition}'
