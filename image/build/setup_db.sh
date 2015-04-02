#!/bin/bash

echo 'Starting mysqld'
# The sleep 1 is there to make sure that inotifywait starts up before the socket is created
mysqld_safe &

echo 'Waiting for mysqld to come online'
while [ ! -x /var/run/mysqld/mysqld.sock ]; do
    sleep 1
done

echo 'Creating bubbla database and user'
mysql -proot < /root/setup_db.sql

echo 'Shutting down mysqld'
mysqladmin -uroot -proot shutdown
