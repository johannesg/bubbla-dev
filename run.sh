#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

OWNER=$(stat -c '%u' $DIR/news-settings)
GROUP=$(stat -c '%g' $DIR/news-settings)

if [ ! -f $DIR/news/sites/default/settings.php ]; then
    echo "Copying settings.php"
    cp $DIR/news-settings/settings.php $DIR/news/sites/default
    chown $OWNER:$GROUP $DIR/news/sites/default/settings.php
fi

if [ ! -d $DIR/news/sites/default/files ]; then
    echo "Creating directory news/sites/default/files"
    mkdir $DIR/news/sites/default/files
    chown $OWNER:$GROUP $DIR/news/sites/default/files
fi

docker run -d \
    -p 8080:80 \
    -v $DIR/backups:/var/lib/mysql/backup:rw \
    -v $DIR/news:/var/www:rw \
    --name bubbla-news \
    bubbla-news \
    /sbin/my_init --enable-insecure-key

