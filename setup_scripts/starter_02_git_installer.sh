#!/bin/bash

# Config of the script
# Please edit  and change to your user data
YOUR_GIT_USER_NAME="PleaseEnterYourName"
YOUR_GIT_EMAIL="PleaseEnterYourEMailAdress"

# install a code version control system
sudo apt-get install git

# register your user account
git config --global user.name $YOUR_GIT_USER_NAME
git config --global user.email $YOUR_GIT_EMAIL

# register nano as our default text editor
git config --global core.editor nano
