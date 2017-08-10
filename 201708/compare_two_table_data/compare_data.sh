while read dir_path
do
    echo $dir_path
    cd ${dir_path}
    cat data | awk -F"\t" '{
        for(i=1;i<=NF/2;i++){
           if($i != $(NF/2+i)){
              print i": "$i" <> "$(NF/2+i)
           }
        }
    }' > compare_res
    cd -
done < 'run_list.cfg'
