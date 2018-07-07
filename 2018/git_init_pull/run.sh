#!/bin/bash

function init(){
  mkdir WH_PROJECT
  for line in $(cat project_directory)
  do
    file_name="WH_PROJECT/"`echo $line | awk -F"/" '{line=$1;for(i=2;i<NF;i++){line=line"/"$i}}END{print line}'`
    if [ ! -d $file_name ]
    then
      mkdir -p $file_name
    fi

    cd $file_name
      git clone ssh://git@git.host:port/${line}.git
    cd -
  done
}

function pull(){
  for line in $(cat project_directory)
  do
    cd "WH_PROJECT/"$line
      echo $line
      git pull
    cd -
  done
}


case $1 in
   init)
        echo "git clone all repo"
        init
        ;;
   pull)
        echo "git pull all repo"
        pull
        ;;
   *)
        echo "wrong parameter"
esac
