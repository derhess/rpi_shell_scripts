# Some Shell Installation Script for Raspberry Pi

This projects maintains some setup and installations scripts for local Web Development experiments. The code 
is at the moment splitted into two folders. One folder for installations and setup scripts. The other folder
contains some dameon services for systemd. 

##Setup Installations
- Setup git on your Raspberry Pi and configure it a little bit
- Setup a set of different NodeJS runtimes with NVM and install PM2 as nodejs app process manager
- Setup a CouchDB database with systemd as boot starter

##Services for systemd
- CouchDB service, so that CouchDB gets startet after boot process
- nginx server should start from the beginning
