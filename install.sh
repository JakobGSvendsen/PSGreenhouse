sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt-get install screen
sudo mkdir pswh 
sudo curl -fsSL https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/ghouseConfig_example.json -o /home/pi/pswh/GHouseConfig.json
sudo curl -fsSL https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/ghouse-init.sh -o /home/pi/ghouse-init.sh
sudo chmod 777 /home/pi/ghouse-init.sh
sudo curl -fsSL https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/rc.local -o /etc/rc.local