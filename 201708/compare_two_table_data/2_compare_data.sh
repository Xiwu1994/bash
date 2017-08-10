:> compare_res
while read dir_path
do
    echo $dir_path >> compare_res
    echo  >> compare_res
    cat ${dir_path}/data | awk -F"\t" '{
        print "===key===: "$1
        for(i=1;i<=NF/2;i++){
           if($i != $(NF/2+i)){
              print i": "$i" <> "$(NF/2+i)
           }
        }
    }' >> compare_res
    
done < 'run_list.cfg'
