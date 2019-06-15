# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

FROM arm32v7/ubuntu:bionic

ENV PS_VERSION=6.2.0
ENV PS_PACKAGE=powershell-${PS_VERSION}-linux-arm32.tar.gz
ENV PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}
ENV WIRINGPI_CODES=1

RUN \
  apt-get update \
  && apt-get install --no-install-recommends ca-certificates libunwind8 libssl1.0 libicu60 wget unzip --yes \
  && wget https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE} \
  && mkdir ~/powershell \
  && tar -xvf ./${PS_PACKAGE} -C ~/powershell \
  && ln -s /root/powershell/pwsh /usr/bin/pwsh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN \
  mkdir ~/greenhouse \
  && cd ~/greenhouse \
  && wget https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/greenhouse0.4.ps1 \
  && wget https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/iot.zip \
  && unzip .\iot.zip \
  && wget https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/start.sh

ENTRYPOINT ["~/greenhouse/start.sh"]
