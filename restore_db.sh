#!/bin/bash

file=$1

if [ "$file" = "" ]; then
    echo "no backup file choosen"
    exit
fi

if [ ! -f $file ]; then
    echo "file $file not found"
    exit
fi

docker exec -it bubbla-news /root/restore_db.sh `basename $file`
