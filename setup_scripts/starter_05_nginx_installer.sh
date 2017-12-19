#!/bin/bash

NGINX_USER="nginx"
NGINX_USER_GROUP="nginx"
NGINX_DOWNLOAD_FOLDER_NAME="nginx_dl"
NGINX_DOWNLOAD_FOLDER_TARGET_PATH="/home/pi"
NGINX_INSTALLATION_TARGET_FOLDER="/usr/sbin/nginx"
NGINX_WWW_FOLDER_PATH="/home/nginx/www"

NGINX_DOWNLOAD_MIRROR="http://nginx.org/download/nginx-1.13.7.tar.gz"
NGINX_DAEMON_SYSTEMD_SERVICE_FILE_PATH="/home/pi/rpi_shell_scripts/systemd_scripts/nginx.service"
NGINX_DAEMON_SYSTEMD_SERVICE_TARGET="/etc/systemd/system/nginx.service"

NGINX_GEO_IP_IS_ACTIVE=true
NGINX_GEO_IP_DOWNLOAD_MIRROR="http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.5.tar.gz"

echo "Installing nginx"
cd $NNGINX_DOWNLOAD_FOLDER_TARGET_PATH
mkdir $NGINX_DOWNLOAD_FOLDER_NAME 

#Installing dependencies
echo "Prepare dependencies for installation"
sudo apt-get install libpcre3 libpcre3-dev
sudo apt-get update
sudo apt-get install libssl-dev

#Install GD lib on Raspberry Pi for some special nginx module
# see also https://github.com/fsphil/fswebcam/issues/4
sudo apt-get install libgd2-noxpm-dev


#Install GeoIP for the nginx GeoIP module
# https://it.awroblew.biz/category/hardware/raspberrypi/
if [ "$NGINX_GEO_IP_IS_ACTIVE" = true ] ; then
	echo "Install Geo IP Dependency"
	wget $NGINX_GEO_IP_DOWNLOAD_MIRROR
	tar -xvf GeoIP-1.*.tar.gz
	./configure
	make
	make check
	make install
fi

echo "Download nginx version 1.x  from the server"
wget $NGINX_DOWNLOAD_MIRROR
tar -xvf nginx-1.*.tar.gz
cd nginx*

# Config the nginx server
echo "configure the nginx installation with additional modules"
./configure --user=$NGINX_USER \
	 --group=$NGINX_USER_GROUP \
	--prefix=/etc/nginx \
	--sbin-path=$NGINX_INSTALLATION_TARGET_FOLDER \
	--conf-path=/etc/nginx/nginx.conf \
	--pid-path=/var/run/nginx.pid \
	--lock-path=/var/run/nginx.lock \
	--error-log-path=/var/log/nginx/error.log \
	--http-log-path=/var/log/nginx/access.log \
	--with-http_gunzip_module --with-http_secure_link_module \
	--with-http_auth_request_module \
	--with-http_gzip_static_module \
	--with-http_stub_status_module \
	--with-http_ssl_module \
	--with-pcre \
	--with-file-aio \
	--with-http_realip_module \
	--with-stream \
	--with-stream_ssl_module \
	--with-debug \
	--with-http_flv_module \
	--with-http_mp4_module \
	--with-http_dav_module \
	--with-http_sub_module \
	--with-http_geoip_module \
	--with-http_addition_module \
	--with-http_v2_module \
	--with-http_image_filter_module \
	--with-http_degradation_module \
	--without-http_scgi_module \
	--without-http_uwsgi_module

# Compile and Install nginx
echo "Compile and Install nginx"
make && sudo make install


# Adapt the installation 
echo "create nginx user"
# config nginx for user management and booting process of the rPI
# create user for nginx server
sudo useradd -r $NGINX_USER;

#Test Nginx version
echo "Start and check the nginx server version"
#test run the nginx Server. The output should be version 1.xx.x
$NGINX_INSTALLATION_TARGET_FOLDER -v

#Register Daemon Service
sudo cp $NGINX_DAEMON_SYSTEMD_SERVICE_FILE_PATH $NGINX_DAEMON_SYSTEMD_SERVICE_TARGET

sudo systemctl enable nginx.service
sudo systemctl start nginx.service
sudo systemctl status nginx.service
 
#Optional for fast restart command via xrestart
alias xrestart="sudo systemctl restart nginx.service"


#Create the www folder for your static web files
echo "Create the www folder, where you can run your static webfiles"
sudo mkdir -p $NGINX_WWW_FOLDER_PATH
#change user rights of the folder
sudo chmod -R 775  $NGINX_WWW_FOLDER_PATH
sudo chgrp -R $NGINX_USER_GROUP $NGINX_WWW_FOLDER_PATH


#clean installation folder
echo "clean some the installation folders"
sudo rm -rf $NGINX_DOWNLOAD_FOLDER_TARGET_PATH"/"$NGINX_DOWNLOAD_FOLDER_NAME"/"

