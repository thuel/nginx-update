#!/bin/bash

case $1 in
  --prepare)
    if [ -z $2 ]; then
      echo "usage:  nginxupd --prepare <version>|--upgrade|--complete"
      exit 1
    else
      version=$2
    fi
    old_version=$(ls -r /usr/local/ | grep nginx- | head -n 1)
    cd /usr/local/src
    wget http://nginx.org/download/nginx-$version.tar.gz
    tar xfvz nginx-$version.tar.gz
    cd nginx-$version
    ./configure --user=www-data --group=www-data --prefix=/usr/local/nginx-$version --conf-path=/usr/local/nginx-$version/nginx.conf --pid-path=/var/run/nginx.pid --lock-path=/var/lock/nginx.lock --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_xslt_module --with-http_image_filter_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gzip_static_module --with-http_secure_link_module --with-http_stub_status_module
    make
    make install
    cd /usr/local
    ln -snf /usr/local/nginx-$version nginx
    ln -snf /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
    cp nginx-$old_version/sneffets.ch* nginx-$version/
    cp -R nginx-$old_version/sites-* nginx-$version/
    cp nginx-$old_version/nginx.conf nginx-$version/
    exit 0
    ;;
  --upgrade)
    kill -s USR2 $(sudo cat /run/nginx.pid)
    kill -s USR2 $(sudo cat /run/php5-fpm.pid) # zu prüfen, funktioniert hat es mit einem restart von nginx und php5-fpm
    kill -s WINCH $(sudo cat /run/nginx.pid.oldbin)
    exit 0
    ;;
  --complete)
    kill -s QUIT $(sudo cat /run/nginx.pid.oldbin)
    exit 1
    ;;
  *)
    echo "usage: nginxupd --prepare <version>|--upgrade|--complete"