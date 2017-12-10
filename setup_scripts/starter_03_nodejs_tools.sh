#!/bin/bash

echo "Installing NodeJS dependencies"

# Install  nodejs dependencies
sudo apt-get install build-essential checkinstall
sudo apt-get install libssl-dev

echo "Install NVM for running several NodeJS and NPM installations"

# Download nvm and run the installation script, please check for the current version
# Here Please add your versions
NVM_INSTALLER_LINK="https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh"
NODE_JS_LTS="8.9.1"
NODE_JS_CURRENT="9.2.0"

if [ ! -d ~/.nvm ]; then
	echo "NVM doesnot exist on your machine, the installer script runs"
	curl -o- $NVM_INSTALLER_LINK | bash
	source ~/.nvm/nvm.sh
  	source ~/.profile
  	source ~/.bashrc
else
	echo "NVM is already installed"
	# Register the  nvm for the bash script
	source ~/.nvm/nvm.sh
  	source ~/.profile
  	source ~/.bashrc
fi

#test installation of nvm
echo "Checkout the NVM version"
command -v nvm


echo "Install NodeJS and NPM as LTS und Current Version"
#install nodejs current node runtimes. Depends on your wishes
nvm install $NODE_JS_LTS
nvm install $NODE_JS_CURRENT
 
# check your nodejs installed runtimes
echo "Checkout the installed NodeJS runtimes"
nvm ls
 
# choose your preferred nodejs runtime and assign it to your default
echo "NodeJS current is set to default NodeJS and NPM runtime"
nvm use "v$NODE_JS_CURRENT"
nvm alias default node
 

#test your running node and npm. The output should be the same as your chosen runtime
echo "Checkout the active NodeJS and NPM runtime"
node -v  
npm -v


# optional install a node process manager
echo "PM2 will be installed as our NodeJS process manager"
npm install -g pm2
 
#restart your system
echo "We recommend you to reboot your computer"
