# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

FROM arm32v7/ubuntu:bionic

ENV PS_VERSION=7.0.0-preview.5
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
  GHOUSE_TOOLS_VERSION=0.0.1 \
  && mkdir ~/greenhouse \
  && cd ~/greenhouse \
  && wget https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/iot.zip \
  && unzip iot.zip

RUN \
  GHOUSE_VERSION=0.4.6 \
  && cd ~/greenhouse \
  && wget -O greenhouse.ps1 https://raw.githubusercontent.com/JakobGSvendsen/PSGreenhouse/master/greenhouse${GHOUSE_VERSION}.ps1 

ENTRYPOINT ["pwsh"]
CMD ["/root/greenhouse/greenhouse.ps1"]
