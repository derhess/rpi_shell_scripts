#!/bin/bash
COUCH_DB_DOWNLOAD_FOLDER_NAME="couch"
COUCH_DB_DOWNLOAD_FOLDER_TARGET_PATH="/home/pi"
COUCH_DB_FOLDER="/home/couchdb"
COUCH_DB_DOWNLOAD_MIRROR="http://apache.mirror.digionline.de/couchdb/source/2.1.1/apache-couchdb-2.1.1.tar.gz"
COUCH_DB_LOCAL_INI_FILE_PATH="/home/pi/rpi_shell_scripts/other_configs/couchdb/local.ini"
COUCH_DB_DAEMON_SYSTEMD_SERVICE_FILE_PATH="/home/pi/rpi_shell_scripts/systemd_scripts/couchdb.service"
COUCH_DB_DAEMON_SYSTEMD_SERVICE_TARGET="/etc/systemd/system/couchdb.service"

echo "Installing CouchDB"
cd $COUCH_DB_DOWNLOAD_FOLDER_TARGET_PATH
mkdir $COUCH_DB_DOWNLOAD_FOLDER_NAME
cd $COUCH_DB_DOWNLOAD_FOLDER_NAME

#Installing dependencies
echo "Prepare dependencies for installation"
wget http://packages.erlang-solutions.com/debian/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc

sudo apt-get update

sudo apt-get install -y erlang-nox erlang-dev erlang-reltool
sudo apt-get install -y build-essential
sudo apt-get install -y libmozjs185-1.0 libmozjs185-dev
sudo apt-get install -y libcurl4-openssl-dev libicu-dev

#Setup the couchdb user and create a home folder for the 'couchdb' user
echo "Create CouchDB Folder and user"
sudo useradd -d $COUCH_DB_FOLDER couchdb
sudo mkdir $COUCH_DB_FOLDER
sudo chown couchdb:couchdb $COUCH_DB_FOLDER

# download source code
echo "Downloach CouchDB Sources for Version 2.x"
cd $COUCH_DB_DOWNLOAD_FOLDER_TARGET_PATH"/"$COUCH_DB_DOWNLOAD_FOLDER_NAME
wget $COUCH_DB_DOWNLOAD_MIRROR
tar zxvf apache-couchdb-2.*.tar.gz
cd apache-couchdb-2.*/

#start compiling
echo "start compiling the CouchDB sources"
./configure
make release

# changing the owner and location of couch db running system! 
# Here you can adapt the everything on your personal needs
echo "Your CouchDB should compiled successfully"
echo "Next step is the configuration on your system"
cd ./rel/couchdb
pwd
echo "Copy the CouchDB directory to the folder:"$COUCH_DB_FOLDER
sudo cp -Rp * $COUCH_DB_FOLDER
sudo chown -R couchdb:couchdb $COUCH_DB_FOLDER

#configure the admin UI System
echo "copy new local.ini config file to couchdb - just changed the chttp local bind_address to 0.0.0.0 "
sudo mv $COUCH_DB_FOLDER"/etc/local.ini" $COUCH_DB_FOLDER"/etc/local.ini.orig"
sudo cp $COUCH_DB_LOCAL_INI_FILE_PATH $COUCH_DB_FOLDER"/etc/"

#clean installation folder
echo "clean some the installation folders"
sudo rm -rf $COUCH_DB_DOWNLOAD_FOLDER_TARGET_PATH"/"$COUCH_DB_DOWNLOAD_FOLDER_NAME"/"


#Create, Register and Install a CouchDB Starter service after system reboot
echo "Create a systemd service for CouchDB"
sudo cp $COUCH_DB_DAEMON_SYSTEMD_SERVICE_FILE_PATH $COUCH_DB_DAEMON_SYSTEMD_SERVICE_TARGET

#Register your systemd service
sudo systemctl daemon-reload
sudo systemctl start couchdb.service
sudo systemctl enable couchdb.service

#test start
echo "CouchDB is started an available under http://your_ip:5984/_utils"
# run couch DB 2.x the first time
echo "You can start CouchDB manually with this command"
echo "sudo -i -u couchdb "$COUCH_DB_FOLDER"/bin/couchdb"

echo "A system reboot via sudo reboot is highly recommended"


