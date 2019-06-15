sudo docker build --tag greenhouse "https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/Dockerfile"
sudo docker run --interactive --tty --privileged greenhouse

screen sudo docker run --interactive --tty --privileged greenhouse

 INSTALL-Module Microsoft.PowerShell.IoT -Force
 Import-Module Microsoft.PowerShell.IoT


screen powershell /home/pi/pswh/greenhouse0.1.ps1
sudo nano /etc/rc.local
