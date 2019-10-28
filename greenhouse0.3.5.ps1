$Version = "0.3.6"
get-job | stop-job -PassThru | Remove-Job
cd $PSScriptRoot
$ErrorActionPreference = "Stop"
Import-Module ./iot/Microsoft.PowerShell.IoT/
Get-GpioPin #to init PI. TODO fix the code in IoT module to trigger the init when loading

$global:Relay1Pin = 26
$global:Relay2Pin = 19
$global:Relay3Pin = 13
$global:Relay4Pin = 6

$global:Relay1State = 0
$global:Relay2State = 0
$global:Relay3State = 0
$global:Relay4State = 0
$global:AppSettings = Get-Content ./GHouseConfig.json | ConvertFrom-Json

$startTime = Get-Date

#Add-Type -PassThru -Path ".\iot\Unosquare.Swan.Lite.dll"
Add-Type -PassThru -Path ".\iot\Unosquare.RaspberryIO.dll"
Add-Type -PassThru -Path ".\iot\Unosquare.Raspberry.Abstractions.dll"
Add-Type -PassThru -Path ".\iot\Unosquare.RaspberryIO.Peripherals.dll"

Function Get-Configuration {
    param(
        $APIKey = $global:AppSettings.GetApiKey,
        $Uri = $global:AppSettings.GetUri
    )
    $Headers = @{
        "x-functions-key" = $APIKey
    }
    $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing -Headers $Headers
    $response.Content | ConvertFrom-JSON
}

Function Handle-Configuration {
    param($Configuration)

    if ($Configuration.Valve1 -eq "ON") {
        Write-Output "Turning Value 1 on"
        Set-GpioPin -Id $global:Relay1Pin -Value "High"
        $Global:Relay1State = 1
    }
    else {
        Write-Output "Turning Value 1 Off"
        Set-GpioPin -Id $global:Relay1Pin -Value "Low"
        $Global:Relay1State = 0
    }
    if ($Configuration.Valve2 -eq "ON") {
        Write-Output "Turning Value 2 on"
        Set-GpioPin -Id $global:Relay2Pin -Value "High"
        $Global:Relay2State = 1
    }
    else {
        Write-Output "Turning Value 2 Off"
        Set-GpioPin -Id $global:Relay2Pin -Value "Low"
        $Global:Relay2State = 0
    }

    if ($Configuration.Valve3 -eq "ON") {
        Write-Output "Turning Value 3 on"
        Set-GpioPin -Id $global:Relay3Pin -Value "High"
        $Global:Relay3State = 1
    }
    else {
        Write-Output "Turning Value 3 Off"
        Set-GpioPin -Id $global:Relay3Pin -Value "Low"
        $Global:Relay3State = 0
    }

    if ($Configuration.Valve4 -eq "ON") {
        Write-Output "Turning Value 4 on"
        Set-GpioPin -Id $global:Relay4Pin -Value "High"
        $Global:Relay4State = 1
    }
    else {
        Write-Output "Turning Value 4 Off"
        Set-GpioPin -Id $global:Relay4Pin -Value "Low"
        $Global:Relay4State = 0
    }

}

Function Start-DHT {

    UnRegister-Event -SourceIdentifier "OnDataAvailable" -ErrorAction SilentlyContinue
    $pin = [Unosquare.RaspberryIO.Pi]::Gpio | where PhysicalPinNumber -eq 29
    $sensor = [Unosquare.RaspberryIO.Peripherals.DhtSensor]::Create([Unosquare.RaspberryIO.Peripherals.DhtType]::Dht22, $pin)
    
    $actionOnDataAvailable = {
        $VerbosePreference = "Continue"
        $ErrorActionPreference = "Stop"
        
        if ($event.SourceEventArgs.IsValid) {
            
            write-verbose ($event.SourceEventArgs | out-string)
            #if(!(Get-Command Get-GpioPin -ErrorAction SilentlyContinue)){
            # Import-Module ./iot/Microsoft.PowerShell.IoT/ -Cmdlet Get-GpioPin
            #}
            $APIKey = $event.MessageData.SendApiKey
            $Uri = $event.MessageData.SendUri
       
            $Headers = @{
                "x-functions-key" = $APIKey
            } 
           
            $Humidity = $event.SourceEventArgs.HumidityPercentage
            $Temperature_C = $event.SourceEventArgs.Temperature
            $Temperature_F = $event.SourceEventArgs.TemperatureFahrenheit
            # $Relay_1 = if((Get-GpioPin -Id 13).value -eq "High"){1}else{0}
            # $Relay_2 = if((Get-GpioPin -Id 26).value -eq "High"){1}else{0}
            # $Relay_4 = if((Get-GpioPin -Id 19).value -eq "High"){1}else{0}

            
            #send metric alpha
            #"{\"Name\":\"Home\",\"Humidity\":%d,\"Temperature_C\":%d.%02d,\"Temperature_F\":%d.%02d,\"Soil_1\":%d,\"Soil_2\":%d,\"Soil_3\":%d,\"Soil_4\":%d,\"Soil_5\":%d,\"Soil_6\":%d,\"Relay_1\":%d,\"Relay_2\":%d,\"Relay_3\":%d,\"Relay_4\":%d}",
            $MetricObject = [pscustomobject]@{
                Name          = $(hostname) #"HomePS"
                Humidity      = $Humidity
                Temperature_C = $Temperature_C
                Temperature_F = $Temperature_F
                #Soil_1 = 800
                #Soil_2 = 800
                #Soil_3 = 800
                #Soil_4 = 800
                Relay_1       = $Global:Relay1State
                Relay_2       = $Global:Relay2State
                Relay_3       = $Global:Relay3State
                Relay_4       = $Global:Relay4State
            }
            write-verbose $MetricObject
                
            try {
                $Body = $MetricObject | COnvertTo-JSON
                $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing -Method Post -Body $Body -Headers $Headers
                $response
            }
            catch {
                write-verbose $_
            }
            #    $event
            #$event.SourceEventArgs
        }
    
    }
    Register-ObjectEvent -InputObject $sensor -EventName "OnDataAvailable" -Action $actionOnDataAvailable -MessageData $global:AppSettings
    $sensor.Start(30) #every 30 seconds

} #Function Start-DHT{


Write-Output "Sending Metrics"
Start-DHT
$VerbosePreference = "Continue"
$shouldRun = $true
while ($shouldRun) {
    Write-Output "Start Loop: $(Get-Date)"  
    Write-Output "Version: $Version"
    try {
        Write-Output "Getting Configuration"
        $Configuration = Get-Configuration
        $Configuration
        Write-Output "Handling Configuration"
        Handle-Configuration -Configuration $Configuration

        get-job | Receive-Job | out-string

        #Log Time
        Write-Output "Start Time: $startTime"
        $Duration = ((get-date) - $startTime).TotalHours
        Write-Output "Duration: $Duration Hours"
    }
    catch {
        Write-Output "Loop failed - Error:"
        Write-Output $_

        #Force it to continue on below commands, as these are resettting the machine and rebooting in the end.
        $ErrorActionPreference = "silentlycontinue"
        #Turn off all pumps
        Set-GpioPin -Id $global:Relay1Pin -Value "Low" 
        Set-GpioPin -Id $global:Relay2Pin -Value "Low"
        Set-GpioPin -Id $global:Relay3Pin -Value "Low"
        Set-GpioPin -Id $global:Relay4Pin -Value "Low"

        #Restart computer
        Restart-Computer -Force
    }

    Write-Output "Waiting 15 seconds"
    Write-Output "End Loop: $(Get-Date) - www.ctglobalservices.com"
    Start-Sleep -Seconds 15
}

