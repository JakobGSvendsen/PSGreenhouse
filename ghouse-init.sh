su pi -c ' screen && sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q) && sudo docker build --tag greenhouse "https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/Dockerfile" && sudo docker run --interactive --tty --privileged -v /home/pi/pswh/GHouseConfig.json:/root/greenhouse/GHouseConfig.json greenhouse'

