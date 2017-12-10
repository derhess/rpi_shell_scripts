#!/bin/bash

echo "Update your Raspberry Pi!"

# update system and be sure that we get everything
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get upgrade
