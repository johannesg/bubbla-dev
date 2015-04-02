#!/bin/bash

file=$1

if [ "$file" = "" ]; then
    echo "no backup file choosen"
    exit
fi

file="/var/lib/mysql/backup/$file"

if [ ! -f $file ]; then
    echo "file $file not found"
    exit
fi

echo "Restoring database $file"
mysql -proot bubbla < "$file"
echo "Restore complete"
