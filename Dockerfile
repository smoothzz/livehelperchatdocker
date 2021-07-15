FROM debian:stable

MAINTAINER Suporte "suporte@paschoalotto.com.br"

WORKDIR /var/www/livehelperchat/lhc_web

RUN apt update && apt -y install lsb-release apt-transport-https ca-certificates && apt-get install -y wget && apt-get install -y unzip && apt-get install nginx -y && apt clean

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

RUN apt update -y

RUN apt install -y php7.4 php-cas php7.4-fpm php7.4-curl php7.4-gd php7.4-imagick php7.4-intl \
	    php7.4-apcu php7.4-memcache php7.4-imap php7.4-mysql \
	    php7.4-ldap php7.4-tidy php-pear php7.4-xmlrpc php7.4-pspell \
	    php7.4-mbstring php7.4-json php7.4-iconv php7.4-xml php7.4-xsl \
	    php7.4-zip php7.4-bz2 \
	    && apt-get clean

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN cd /tmp \
		&& wget https://github.com/remdex/livehelperchat/archive/master.zip \
		&& unzip master.zip \
		&& rm -rf /var/www/livehelperchat/ \
		&& mv livehelperchat-master /var/www/livehelperchat \
		&& rm -rf master.zip

RUN chown -R www-data:www-data /var/www/livehelperchat/ && chmod -R 755 /var/www/livehelperchat/ && rm -f /etc/nginx/sites-enabled/default && rm -rf /etc/php/7.4/fpm/php.ini

COPY default /etc/nginx/sites-enabled/
COPY php.ini /etc/php/7.4/fpm/

EXPOSE 80

CMD service php7.4-fpm start && nginx
