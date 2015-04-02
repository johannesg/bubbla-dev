#!/bin/bash

file="bubbla_`date +%Y%m%d%H%M%S`.sql"
dir="/var/lib/mysql/backup"

OWNER=$(stat -c '%u' $dir) 
GROUP=$(stat -c '%g' $dir)

echo "Dumping database to file $file in the backup folder"
mysqldump -proot --databases bubbla > "$dir/$file"
echo "Dump complete"

chown $OWNER:$GROUP "$dir/$file"
