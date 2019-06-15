get-job | stop-job -PassThru | Remove-Job
Import-Module /home/pi/iot/Microsoft.PowerShell.IoT/
Get-GpioPin #to init PI. TODO fix the code in IoT module to trigger the init when loading
cd $PSScriptRoot
$global:Configuration = Get-Content ./GHouseConfig.json | ConvertFrom-Json


<#
#saved for docker auto download 
invoke-webrequest -uri "http://www.bk-kapow.dk/jgs/Unosquare.RaspberryIO.Peripherals.dll" -OutFile .\Unosquare.RaspberryIO.Peripherals.dll
invoke-webrequest -uri "http://www.bk-kapow.dk/jgs/Unosquare.Raspberry.Abstractions.dll" -OutFile .\Unosquare.Raspberry.Abstractions.dll
invoke-webrequest -uri "http://www.bk-kapow.dk/jgs/Unosquare.RaspberryIO.dll" -OutFile .\Unosquare.RaspberryIO.dll
#>
Add-Type -PassThru -Path ".\Unosquare.Swan.Lite.dll"
Add-Type -PassThru -Path ".\Unosquare.RaspberryIO.dll"
Add-Type -PassThru -Path ".\Unosquare.Raspberry.Abstractions.dll"
Add-Type -PassThru -Path ".\Unosquare.RaspberryIO.Peripherals.dll"

Function Get-Configuration {
    param(
        $APIKey = $global:Configuration.GetApiKey,
        $Uri = $global:Configuration.GetUri
    )
    $Headers = @{
        "x-functions-key" = $APIKey
    }
    $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing -Headers $Headers
    $response.Content | ConvertFrom-JSON
}

Function Handle-Configuration{
param($Configuration)

if($Configuration.Valve1 -eq "ON") {
    Write-Output "Turning Value 1 on"
    Set-GpioPin -Id 13 -Value "High"
} else {
   Write-Output "Turning Value 1 Off"
    Set-GpioPin -Id 13 -Value "Low"
}
if($Configuration.Valve2 -eq "ON") {
    Write-Output "Turning Value 2 on"
    Set-GpioPin -Id 26 -Value "High"
} else {
   Write-Output "Turning Value 2 Off"
    Set-GpioPin -Id 26 -Value "Low"
}

if($Configuration.Valve4 -eq "ON") {
    Write-Output "Turning Value 4 on"
    Set-GpioPin -Id 19 -Value "High"
} else {
   Write-Output "Turning Value 4 Off"
    Set-GpioPin -Id 19 -Value "Low"
}

}

Function Start-DHT{

    UnRegister-Event -SourceIdentifier "OnDataAvailable" -ErrorAction SilentlyContinue
    $pin = [Unosquare.RaspberryIO.Pi]::Gpio | where PhysicalPinNumber -eq 29
    $sensor = [Unosquare.RaspberryIO.Peripherals.DhtSensor]::Create([Unosquare.RaspberryIO.Peripherals.DhtType]::Dht22,$pin)
    
    $actionOnDataAvailable = {
        $VerbosePreference = "Continue"
        $APIKey = $event.MessageData.SendApiKey
        $Uri = $event.MessageData.SendUri
    
        $Headers = @{
            "x-functions-key" = $APIKey
        }
        if($event.SourceEventArgs.IsValid)
        {
           write-verbose ($event.SourceEventArgs|out-string)
            $Humidity = $event.SourceEventArgs.HumidityPercentage
            $Temperature_C = $event.SourceEventArgs.Temperature
            $Temperature_F = $event.SourceEventArgs.TemperatureFahrenheit
            $Relay_1 = if((Get-GpioPin -Id 13).value -eq "High"){1}else{0}
            $Relay_2 = if((Get-GpioPin -Id 26).value -eq "High"){1}else{0}
            $Relay_4 = if((Get-GpioPin -Id 19).value -eq "High"){1}else{0}

            
            #send metric alpha
                #"{\"Name\":\"Home\",\"Humidity\":%d,\"Temperature_C\":%d.%02d,\"Temperature_F\":%d.%02d,\"Soil_1\":%d,\"Soil_2\":%d,\"Soil_3\":%d,\"Soil_4\":%d,\"Soil_5\":%d,\"Soil_6\":%d,\"Relay_1\":%d,\"Relay_2\":%d,\"Relay_3\":%d,\"Relay_4\":%d}",
                $MetricObject = [pscustomobject]@{
                    Name = "HomePS"
                    Humidity = $Humidity
                    Temperature_C = $Temperature_C
                    Temperature_F = $Temperature_F
                    Soil_1 = 800
                    Soil_2 = 800
                    Soil_3 = 800
                    Soil_4 = 800
                    Relay_1 = $Relay_1 
                    Relay_2 = $Relay_2
                    Relay_3 = "HIGH"
                    Relay_4 = $Relay_4
                    }
                write-verbose $MetricObject
                
                try {
                $Body = $MetricObject | COnvertTo-JSON
                $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing -Method Post -Body $Body -Headers $Headers
                $response
                } catch {
                write-verbose $_
                }
        #    $event
        #$event.SourceEventArgs
        }
    
    }
    Register-ObjectEvent -InputObject $sensor -EventName "OnDataAvailable" -Action $actionOnDataAvailable -MessageData $Configuration
    $sensor.Start(30) #every 30 seconds

} #Function Start-DHT{


    Write-Output "Sending Metrics"
    Start-DHT
$VerbosePreference = "Continue"
$shouldRun = $true
while($shouldRun){
    Write-Output "Start Loop: $(Get-Date)"

    try {
#Write-Output "Sending Metrics"
#Send-Metrics

Write-Output "Getting Configuration"
$Configuration = Get-Configuration
$Configuration
Write-Output "Handling Configuration"
Handle-Configuration -Configuration $Configuration

get-job | Receive-Job|out-string
    } catch {
        Write-Output "Loop failed - Error:"
        Write-Output $_
    }

Write-Output "Waiting 15 seconds"
Write-Output "End Loop: $(Get-Date)"
Start-Sleep -Seconds 15
}

