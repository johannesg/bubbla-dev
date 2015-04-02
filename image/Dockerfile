FROM phusion/baseimage:0.9.16

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# Some Environment Variables
ENV    DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim curl wget build-essential python-software-properties
RUN add-apt-repository -y ppa:ondrej/php5
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

RUN apt-get install -y --force-yes php5-cli php5-fpm php5-mysql php5-curl \
            php5-gd php5-mcrypt php5-intl php5-imap php5-tidy \
            nginx mysql-server

# MySql
ADD build/my.cnf    /etc/mysql/my.cnf

RUN mkdir           /etc/service/mysql
ADD build/mysql.sh  /etc/service/mysql/run
RUN chmod +x        /etc/service/mysql/run

RUN mkdir -p        /var/lib/mysql/
RUN chmod -R 755    /var/lib/mysql/
RUN mkdir -p        /var/lib/mysql/setup/
RUN chmod -R 755    /var/lib/mysql/setup/
RUN mkdir -p        /var/lib/mysql/backup/
RUN chmod -R 755    /var/lib/mysql/backup/

ADD build/setup_db.sql /root/
ADD build/setup_db.sh /root/
ADD build/restore_db.sh /root/
ADD build/dump_db.sh /root/

RUN chmod +x /root/setup_db.sh
RUN chmod +x /root/restore_db.sh
RUN chmod +x /root/dump_db.sh

RUN /root/setup_db.sh

VOLUME /var/lib/mysql/backup

EXPOSE 3306
# END MySQL Installation

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN composer global require drush/drush:6.*
RUN ln -s ~/.composer/vendor/drush/drush/drush /usr/local/bin/
 
RUN mkdir -p        /var/www
VOLUME /var/www

ADD build/default   /etc/nginx/sites-available/default
RUN mkdir           /etc/service/nginx
ADD build/nginx.sh  /etc/service/nginx/run
RUN chmod +x        /etc/service/nginx/run
RUN mkdir           /etc/service/phpfpm
ADD build/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x        /etc/service/phpfpm/run

ADD build/setuser.sh /etc/my_init.d/01_setuser.sh
RUN chmod +x /etc/my_init.d/01_setuser.sh

EXPOSE 80
# Nginx-PHP Installation

# END Nginx-PHP Installation
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
