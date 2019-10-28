# PSGreenhouse !

This library can be used to connect

# Setup  Guide

## Install Raspian on SD Card

Follow the offical guide and install the newest raspian
https://www.raspberrypi.org/documentation/installation/installing-images/README.md

Use any image you want, but I recommend the minimal
Raspbian Buster Lite
Minimal image based on Debian Buster

Setup network and make sure the PI has internet connectivity
https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md

Enable SSH if you want to remote control (Very good idea!)
https://www.raspberrypi.org/documentation/remote-access/ssh/

## Install Docker 

My stuff is based on Trevor Suillian's great intro at youtube
https://www.youtube.com/watch?v=xm-II3YZiqY

Trevor does a great job explaning why and how this works.
For this setup you only need to install docker by using these commands:

1. Install Docker
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

## Install Screen  

1. Install Screen
sudo apt-get install screen

## Setup Greenhouse json config file

To keep secrets out of the repo, we are using a local json config file for api keys etc.

1. Use the ghouseConfig_example.json as a base and add your own values
1. Create folder
sudo mkdir pswh
1. Create file by using command:
sudo nano /home/pi/pswh/GHouseConfig.json
1. Paste modified content from ghouseConfig_example.json
1. Save the file at  /home/pi/pswh/GHouseConfig.json

(File can be placed differently but you will have to update ghouse-init.sh if you do)

## Add Boot script

We want to add a script that is called on boot to start our container in a screen shell (for easy connection)

1. start nano
sudo nano /home/pi/ghouse-init.sh
1. paste content from ghouse-init.sh in this repo
1. Save file
1. Set execute permissions
sudo chmod 777 /home/pi/ghouse-init.sh

## Setup Auto start of docker container using docker file from GitHub

In this solution we're getting the dockerFile directly from github on each boot.
the ghouse-init.sh file is 

Do the following steps
1. open rc.local
sudo nano /etc/rc.local
1. Replace the content with the content from rc.local in this repo
1. Save file

## Post actions
1. Reboot !
sudo reboot
1. Connect to SSH console
1. restore screen
screen -dr

NB! Use Ctrl+a+d to detach screen again when you are done.



## After reboot

