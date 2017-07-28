#!/bin/bash
# 找到该目录下所有  包含 dwa.dwa_order_list 的文件  并将文件里的 dwa.dwa_order_list 替换成  fact_beeper.fact_beeper_order_list
find . -type f | xargs grep dwa.dwa_order_list | awk -F":" '{print $1}' | sort -u | grep -v "dwa" | xargs sed -i "" "s/dwa\.dwa_order_list/fact_beeper\.fact_beeper_order_list/g"
