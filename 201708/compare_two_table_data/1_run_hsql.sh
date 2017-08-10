while read dir_path
do
    echo $dir_path
    cd ${dir_path}
    sh run_hsql.sh
    cd -
done < 'run_list.cfg'
