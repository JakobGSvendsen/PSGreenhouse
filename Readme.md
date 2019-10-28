# PSGreenhouse !

This library can be used to connect

# Install Raspian on SD Card

Follow the offical guide and install the newest raspian
https://www.raspberrypi.org/documentation/installation/installing-images/README.md

Use any image you want, but I recommend the minimal
Raspbian Buster Lite
Minimal image based on Debian Buster

Setup network and make sure the PI has internet connectivity
https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md

Enable SSH if you want to remote control (Very good idea!)
https://www.raspberrypi.org/documentation/remote-access/ssh/

# Quick Installation

The install-sh script from this repo set up most of the configuration.
All you need to do afterwards is to update the config file

Run these commands to install the solution:

sudo curl -fsSL https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/install.sh -o install.sh  
sudo sh install.sh  

## Setup Greenhouse json config file

To keep secrets out of the repo, we are using a local json config file for api keys etc.

1. open file by using command:  
sudo nano /home/pi/pswh/GHouseConfig.json  
1. Paste modified content from ghouseConfig_example.json  
1. Save the file at  /home/pi/pswh/GHouseConfig.json  

(File can be placed differently but you will have to update ghouse-init.sh if you do)

# Manual Installation

## Setup Greenhouse json config file

To keep secrets out of the repo, we are using a local json config file for api keys etc.

1. Use the ghouseConfig_example.json as a base and add your own values  
1. Create folder  
sudo mkdir pswh  
1. Get example config from repo  
sudo curl -fsSL https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/ghouseConfig_example.json -o /home/pi/pswh/GHouseConfig.json  
1. Open file by using command:  
sudo nano /home/pi/pswh/GHouseConfig.json  
1. Paste modified content from ghouseConfig_example.json  
1. Save the file at  /home/pi/pswh/GHouseConfig.json  

(File can be placed differently but you will have to update ghouse-init.sh if you do)

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
1. Get example config from repo  
sudo curl -fsSL https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/ghouseConfig_example.json -o /home/pi/pswh/GHouseConfig.json  
1. Create file by using command:  
sudo nano /home/pi/pswh/GHouseConfig.json  
1. Paste modified content from ghouseConfig_example.json  
1. Save the file at  /home/pi/pswh/GHouseConfig.json  

(File can be placed differently but you will have to update ghouse-init.sh if you do)

## Add Boot script

We want to add a script that is called on boot to start our container in a screen shell (for easy connection)

1. Get the ghouse init file from repo  
sudo curl -fsSL https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/ghouse-init.sh -o /home/pi/ghouse-init.sh  
1. Set execute permissions  
sudo chmod 777 /home/pi/ghouse-init.sh  

## Setup Auto start of docker container using docker file from GitHub

In this solution we're getting the dockerFile directly from github on each boot.
the ghouse-init.sh file is 

Do the following steps
1. get the rc.local from the repo and overwrite local rc.local (NB! if you have any local addons in there, please open the file and copy the lines you need)  
sudo curl -fsSL https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/rc.local -o /etc/rc.local  

## Post actions
1. Reboot !  
sudo reboot
1. Connect to SSH console  
1. restore screen  
screen -dr

NB! Use Ctrl+a+d to detach screen again when you are done.

# Parts
Raspberry PI 3 or 4.

DHT22 2302 Digital Temperature and Humidity Sensor Module - White
https://www.dx.com/p/dht22-2302-digital-temperature-and-humidity-sensor-module-2023234.html#.XbbS1ehKhaQ

4-Channel 5V 12V Relay Module
Example:
https://www.dx.com/p/4-channel-5v-12v-relay-module-w-optocoupler-blue-expanded-version-2080783.html#.XbbSlehKhaQ

1-4 x DC6-12V R385 Aquarium Fish Tank Round Water Air DC Diaphragm Pump
https://www.banggood.com/DC6-12V-R385-Aquarium-Fish-Tank-Round-Water-Air-DC-Diaphragm-Pump-p-1037303.html?rmmds=search