﻿#!/bin/sh -e
docker build --tag greenhouse https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/Dockerfile
docker run --hostname $(hostname) --interactive --rm --tty --privileged -v /home/pi/pswh/GHouseConfig.json:/root/greenhouse/GHouseConfig.json greenhouse