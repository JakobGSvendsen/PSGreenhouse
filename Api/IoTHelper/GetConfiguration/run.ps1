# GET method: each querystring parameter is its own variable
if ($req_query_name) 
{
    $name = $req_query_name 
}

# //***************************************************************************
# // Author:	Jakob Gottlieb Svendsen, www.runbook.guru
# // Purpose:   Update a Sharepoint item using Tao Yangs SharePointSDK Module.
# // Get the module here: https://www.powershellgallery.com/packages/SharePointSDK/
# // USage Example:
# // Update Sharepoint
# //	.\Update-SPOnlineItemScript.ps1 `
# //			-ListName "Enable Office365 User" `
# //			-ListItemId $ItemID `
# //			-Values @{"Status" = "Completed"
# //						"Result" = "License Added"}
# //***************************************************************************
 Function Update-SharePointItem {

Param(
	  	[Parameter(Mandatory=$true)][String]
		$ListName,
		[Parameter(Mandatory=$true)][int]
		$ListItemId,
		[Parameter(Mandatory=$true)][System.Collections.Hashtable]
		$Values,
    $SiteUrl,
    $Credential,
    $isOnline = $true   

	)
	#$SPConnection = Get-AutomationConnection -Name 'SharePoint Online Connection'
	Write-Verbose "SharePoint Site URL: $($SPConnection.SharePointSiteURL)"
		
    #Get List Fields
    Import-Module SharePointSDK -ErrorAction "stop"

    $ListFields = Get-SPListFields -SiteUrl $siteUrl -Credential $credential -IsSharePointOnlineSite $IsOnline -ListName $ListName -verbose  -ErrorAction "stop"
	$UpdateDetails = @{}
	foreach ($key in $Values.Keys)
	{
		$Field = ($ListFields | Where-Object {$_.Title -ieq $key -and $_.ReadOnlyField -eq $false}).InternalName
		if (!$Field) { throw "'$key' field/column not found in SharePoint List $ListName"}
		$UpdateDetails += @{ $Field = $Values[$key]}
	}
	$UpdateDetails
	
	Write-Verbose "`$UpdateDetails = $UpdateDetails"
	#Update a list item
    $UpdateListItem = Update-SPListItem -SiteUrl $siteUrl -Credential $credential -IsSharePointOnlineSite $IsOnline -ListFieldsValues $UpdateDetails -ListItemID $ListItemID -ListName $ListName  -ErrorAction "stop"
    Write-Output "List Item (ID: $ListItemId) updated: $UpdateListItem."

}

$HouseName = $name
$ListName = "Houses"
$SiteUrl = "https://runbookguru.sharepoint.com/greenhouse"
$IsOnline = $true
$username = "xxxxx"
$password = "xxxx" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

#Get House  
$Houses  = Get-SPListItem -SiteUrl $SiteUrl -ListName $ListName -Credential $Credential -IsSharePointOnlineSite $IsOnline 
$House = $Null
$House = $Houses | ? Title -eq $HouseName

if($House -eq $null ) {
    throw "House '$Name' not found"
}

$ReturnData = New-Object PSObject -Property $House | Select-Object Title, Valve1, Valve2, Valve3, Valve4 | ConvertTo-JSON
Out-File -Encoding Ascii -FilePath $res -inputObject $ReturnData



#$Values = @{"Valve1" = "ON"}
#Update-SharePointItem -SiteUrl $SiteUrl -Credential $Credential -ListName $ListName -ListItemId $HOuse.ID -Values $Values
