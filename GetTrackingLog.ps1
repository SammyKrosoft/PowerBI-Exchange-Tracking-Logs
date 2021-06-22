#------------------------------------------------------------
# Customize the following variables to match your environment
# and local repository for the copied tracking logs
#------------------------------------------------------------

#To just list the files or actually copy these
$JustList = $false

#Exchange 2016 or Exchange 2013 or both ?
$Exchange2016Servers = $true
$Exchange2013Servers = $true

#Destination Folder
$DestinationFolder = "c:\temp\Trackinglog"

#How many days ago we want to go back for tracking logs
$RetainedDays = 30

#------------------------------------------------------------
# End of customization
#------------------------------------------------------------

# Beginning of script

function Get-UNCPath {
	param(
		[string]$HostName,
        [string]$LocalPath
        )

    $NewPath = $LocalPath -replace(":","$")
    #delete the trailing \, if found
    if ($NewPath.EndsWith("\")) {
        $NewPath = [Text.RegularExpressions.Regex]::Replace($NewPath, "\\$", "")
    }
    $Uncpath = "\\$HostName\$NewPath"
    Return $Uncpath
}
 

If ($Exchange2016Servers){
    $ExchangeServers= Get-ExchangeServer | ? {$_.AdminDisplayVersion -like "*15.1*"} | % {$_.Name}
}

If ($Exchange2013Servers){
    if ($ExchangeServers.count -gt 0){
        $ExchangeServers += Get-ExchangeServer | ? {$_.AdminDisplayVersion -like "*15.0*"} | % {$_.Name}
    } Else {
        $ExchangeServers = Get-ExchangeServer | ? {$_.AdminDisplayVersion -like "*15.0*"} | % {$_.Name}
    }
}

#putting $ExchangeServers inside $hubservers just to keep same things as the previous script version
$hubservers = $ExchangeServers


Write-host "Found $($hubservers.count) Hub servers/services" -BackgroundColor Yellow -ForegroundColor Blue

foreach ($server in $Hubservers){
        $trackinglog = get-transportservice $server | select MessageTrackingLogPath
        $trackinglogpath = $trackinglog.MessageTrackingLogPath
        $uncPath = get-uncpath $server $trackinglogpath
        $destinationpath = "$DestinationFolder\$server"
        if ( -Not (Test-Path $destinationpath.trim() ))
        {
                New-Item -Path $destinationpath -ItemType Directory
        }

        $Today = (get-date).tolongdatestring()
        $Boundary = (Get-Date).AddDays(-$RetainedDays).tolongdatestring()
        $FileRegEx = 'MSGTRK(\d+)-\d\.\w+'
        Write-Host "Getting MSGTRK files from $uncPath ..." -BackgroundColor magenta -ForegroundColor Blue
        $Trackingfiles = Get-ChildItem -Path $uncPath | Where-Object -FilterScript {$_.Name -match $FileRegEx -and $_.creationtime -gt $boundary}

        if ($JustList){
            write-Host "`$JustList set to `$True, just listing the files with their UNC path instead of copying these to the destination ($destinationpath)..." -ForegroundColor Green
        }
        write-host "Found $($Trackingfiles.count) files total that are aged from $RetainedDays to today" -ForegroundColor red

        foreach ($file in $Trackingfiles){
                $filepath = $uncPath +"\"+$file.name
                if ($JustList)
                {
                        Write-host $filepath
                } Else {
                        write-host "`$JustList set to `$false, copying files" -ForegroundColor red
                        Copy-Item -Path $filepath -destination $destinationpath
                }
        }
}

# End of script