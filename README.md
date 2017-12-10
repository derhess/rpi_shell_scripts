# Some Shell Installation Script for Raspberry Pi

This projects maintains some setup and installations scripts for local Web Development experiments. The code 
is at the moment splitted into two folders. One folder for installations and setup scripts. The other folder
contains some dameon services for systemd. 

## Setup Installations
- Setup git on your Raspberry Pi and configure it a little bit
- Setup a set of different NodeJS runtimes with NVM and install PM2 as nodejs app process manager
- Setup a CouchDB database with systemd as boot starter

## Services for systemd
- CouchDB service, so that CouchDB gets startet after boot process
- nginx server should start from the beginning

## How to use

1. Download the script
2. make the script executable via shell command ```sudo chmod +x your_script.sh```
3. Run your your scrip via ```./your_scrip.sh```

If this all new to you, no problem! Just check these references
* http://www.circuitbasics.com/how-to-write-and-run-a-shell-script-on-the-raspberry-pi/
* https://www.shellscript.sh/index.html
* http://www.circuitbasics.com/useful-raspberry-pi-commands/
* http://rogerdudler.github.io/git-guide/
* http://derhess.de/2017/02/21/local-dev-server-couchdb-2-0-nodejs-raspberrypi/
