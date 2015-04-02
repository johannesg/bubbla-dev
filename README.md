### Development environment for http://bubb.la

Make sure you have docker installed(http://docker.io)

Depending on how docker is installed, you may need to run docker commands as sudo. In that case, prepend all commands with `sudo` 

#### Getting started

* Clone this repository
    * `git clone https://github.com/johannesg/bubbla-dev`
* Fetch the [news](https://github.com/martineriksson/news) repository into the `news/` folder
    * `git submodule init && git submodule update`
* Build the docker image. The name of the image will be `bubbla-news`
    * `./build.sh`
* Create and run the container
    * `./run.sh`
* Open a browser at (http://localhost:8080)

#### Setting up the database

You should now see a drupal installation complaining that no tables exists in the database. you will need to restore a bubb.la mysql dump.

* Put your database dump in the `backups/` folder. The database name is assumed to be `bubbla`, so the dump must either have been created without a database name or with the name `bubbla`
* Restore the database into the docker container
    * `./restore_db.sh backups/bubbla_backup.sql`
* Reload the webpage

You can export the database using `./dump_db.sh`. This will create a mysql dump in `backups/` with the name `bubbla_<currentdate>.sql`

#### Working on the drupal files

The `news/` folder is mounted as a volume inside the container which means that you can do changes directly in any php-file. To see the changes, simply reload you browser. When you are done for the day, you can stop your container and commit your changes.

#### Running commands in the container

You can enter a bash prompt inside the container with this command:

`docker exec -it bubbla-news /bin/bash`

When inside, you can go to `/var/www` to access the website. For example, you can update the site using `drush` (installed by default)

#### Starting and stopping the container

* `docker start bubbla-news`
* `docker stop bubbla-news`

#### Rebuilding

To rebuild and restart the container you need to delete the container(after you stopped it).
* `docker rm bubbla-news`

Then run `./build.sh` and `./run.sh` again

#### Other useful commands

* `docker ps`: See running containers. add a `-a` switch to see even stopped containers.
* `docker stats bubbla-news`: see cpu+memory usage etc.
