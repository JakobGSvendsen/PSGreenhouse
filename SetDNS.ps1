$currentPublicIP = (Invoke-WebRequest -Uri ifconfig.co/json -UseBasicParsing | convertFrom-JSON).ip