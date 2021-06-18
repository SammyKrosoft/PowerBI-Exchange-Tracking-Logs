#------------------------------------------------------------
# Customize the following variables to match your environment
# and local repository for the copied tracking logs
#------------------------------------------------------------

$DestinationFolder = "c:\Trackinglog"

#------------------------------------------------------------
# End of customization
#------------------------------------------------------------


# Beginning of script

function Get-UNCPath {
	param(
		[string]$HostName,
                [string]$LocalPath)

        $NewPath = $LocalPath -replace(":","$")
        #delete the trailing \, if found
        if ($NewPath.EndsWith("\")) {
                $NewPath = [Text.RegularExpressions.Regex]::Replace($NewPath, "\\$", "")
        }
        $Uncpath = "\\$HostName\$NewPath"
        Return $Uncpath
}
 
 
$hubservers = get-exchangeserver |? {$_.serverrole -match "hubtransport"} |% {$_.name}
 
 
foreach ($server in $Hubservers){
$trackinglog = get-transportserver $server | select MessageTrackingLogPath
$trackinglogpath = $trackinglog.MessageTrackingLogPath
 
$uncPath = get-uncpath $server $trackinglogpath
 
$destinationpath = "$DestinationFolder\$server"
if ( -Not (Test-Path $destinationpath.trim() ))
{
New-Item -Path $destinationpath -ItemType Directory
}
 
$RetainedDays = 30
$Today = (get-date).tolongdatestring()
$Boundary = (Get-Date).AddDays(-$RetainedDays).tolongdatestring()
$FileRegEx = 'MSGTRK(\d+)-\d\.\w+'
$Trackingfiles = Get-ChildItem -Path $uncPath | Where-Object -FilterScript {$_.Name -match $FileRegEx -and $_.creationtime -gt $boundary}
foreach ($file in $Trackingfiles){
$filepath = $uncPath +"\"+$file.name
Copy-Item -Path $filepath -destination $destinationpath
}
}

# End of script