#!/bin/sh -e
motion
docker build --tag greenhouse https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/Dockerfile;
docker run --interactive --tty --privileged -v /home/pi/pswh/GHouseConfig.json:/root/greenhouse/GHouseConfig.json  --restart always greenhouse;
