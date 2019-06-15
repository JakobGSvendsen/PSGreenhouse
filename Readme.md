sudo docker build --tag greenhouse "https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/Dockerfile"
sudo docker run --interactive --tty --privileged greenhouse

sudo docker build --tag greenhouse "https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/Dockerfile"
 sudo docker run --interactive --tty --privileged -v /home/pi/pswh/GHouseConfig.json:/root/greenhouse/GHouseConfig.json greenhouse

su pi -c 'sudo docker build --tag greenhouse "https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/Dockerfile"'
su pi -c 'screen sudo docker run --interactive --tty --privileged -v /home/pi/pswh/GHouseConfig.json:/root/greenhouse/GHouseConfig.json greenhouse'


sudo chmod 755 /etc/init.d/ghouse-init
sudo update-rc.d ghouse-init defaults

$ sudo chmod 755 /etc/init.d/ghouse-init
pi@raspberrypi:~ $ sudo update-rc.d ghouse-init defaults
pi@raspberrypi:~ $ sudo cp ghouse-init /etc/init.d/


screen sudo docker run --interactive --tty --privileged greenhouse

 INSTALL-Module Microsoft.PowerShell.IoT -Force
 Import-Module Microsoft.PowerShell.IoT


screen powershell /home/pi/pswh/greenhouse0.1.ps1
sudo nano /etc/rc.local
