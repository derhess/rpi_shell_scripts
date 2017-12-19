#!/bin/bash

NGINX_USER="nginx"
NGINX_USER_GROUP="nginx"
NGINX_DOWNLOAD_FOLDER_NAME="nginx_dl"
NGINX_DOWNLOAD_FOLDER_TARGET_PATH="/home/pi"

#Be careful changing these folder locations
#If you change these folders, please update the nginx.service daemon and the nginx.conf file
NGINX_INSTALLATION_TARGET_FOLDER="/usr/sbin/nginx"
NGINX_CONFIG_TARGET_FOLDER="/etc/nginx"
NGINX_WWW_FOLDER_PATH="/home/nginx/www"

# Linkage the  current nginx source package and
# connect the pre-applied server configurations 
NGINX_DOWNLOAD_MIRROR="http://nginx.org/download/nginx-1.13.7.tar.gz"
NGINX_DAEMON_SYSTEMD_SERVICE_FILE_PATH="/home/pi/rpi_shell_scripts/systemd_scripts/nginx.service"
NGINX_DAEMON_SYSTEMD_SERVICE_TARGET="/etc/systemd/system/nginx.service"
NGINX_DEFAULT_CONFIG_FILE="/home/pi/rpi_shell_scripts/other_configs/nginx/nginx.conf"
NGINX_DEFAULT_HTML_PAGE="/home/pi/rpi_shell_scripts/other_configs/nginx/index.html"

NGINX_GEO_IP_IS_ACTIVE=true
NGINX_GEO_IP_DOWNLOAD_MIRROR="http://geolite.maxmind.com/download/geoip/api/c/GeoIP-1.4.5.tar.gz"

echo "Installing nginx"
cd $NNGINX_DOWNLOAD_FOLDER_TARGET_PATH
mkdir $NGINX_DOWNLOAD_FOLDER_NAME 
cd $NGINX_DOWNLOAD_FOLDER_NAME


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
GEO_IP_MODULE_CONFIG_COMMAND=""
if [ "$NGINX_GEO_IP_IS_ACTIVE" = true ] ; then
	echo "Install Geo IP Dependency"
	wget $NGINX_GEO_IP_DOWNLOAD_MIRROR
	tar -xvf GeoIP-1.*.tar.gz
	cd $NGINX_DOWNLOAD_FOLDER_TARGET_PATH"/"$NGINX_DOWNLOAD_FOLDER_NAME"/GeoIP*/"
	./configure
	make
	make check
	make install

	$GEO_IP_MODULE_CONFIG_COMMAND="--with-http_geoip_module"
fi

echo "Download nginx version 1.x  from the server"
cd $NGINX_DOWNLOAD_FOLDER_TARGET_PATH"/"$NGINX_DOWNLOAD_FOLDER_NAME"/"
wget $NGINX_DOWNLOAD_MIRROR
tar -xvf nginx-1.*.tar.gz
cd nginx*/

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
	--with-debug \
	--with-http_gunzip_module  \
	--with-http_gzip_static_module \
	--with-http_stub_status_module \
	--with-http_realip_module \
	--with-http_auth_request_module \
	--with-http_ssl_module \
	--with-stream_ssl_module \
	--with-http_secure_link_module \
	--with-pcre \
	--with-file-aio \
	--with-stream \
	--with-http_flv_module \
	--with-http_mp4_module \
	--with-http_dav_module \
	--with-http_sub_module \
	$GEO_IP_MODULE_CONFIG_COMMAND \
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
# Copy the default starter wep page 
sudo cp $NGINX_DEFAULT_HTML_PAGE $NGINX_WWW_FOLDER_PATH

#change user rights of the folder
sudo chmod -R 775  $NGINX_WWW_FOLDER_PATH
sudo chgrp -R $NGINX_USER_GROUP $NGINX_WWW_FOLDER_PATH

#change the default  html/www root folder of nginx
sudo cp $NGINX_DEFAULT_CONFIG_FILE $NGINX_CONFIG_TARGET_FOLDER"/nginx.conf"

#clean installation folder
echo "clean some the installation folders"
sudo rm -rf $NGINX_DOWNLOAD_FOLDER_TARGET_PATH"/"$NGINX_DOWNLOAD_FOLDER_NAME"/"
