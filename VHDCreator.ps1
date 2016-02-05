$ErrorActionPreference = "Stop"

function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}
$localPath = (Get-ScriptDirectory) + '\'
#Write-Host $localPath

#Check if environment ok
$feature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell
Write-Host $feature.State
if($feature.State -eq 'Disabled')
{
    Write-Host 'Microsoft-Hyper-V-Tools-Al was not found. Trying to install...Restart required'
    Enable-WindowsOptionalFeature -Online -All -FeatureName Microsoft-Hyper-V-Tools-All
    Exit
}
#End


$vhdpath = $localPath + 'Test.vhdx'

if(Test-Path $vhdpath)
{
Write-Host 'Found previous vhd version'
Write-Host '..Trying to dismount'
Dismount-VHD -Path $vhdPath
Write-Host 'Ok'
Write-Host '..Trying to remove vhd'
Remove-Item $vhdpath
Write-Host 'Ok'
}

##Required to surpress 'Please format your drive message'
Write-Host "Stopping ShellHWDetection service to surpress 'Please format your drive message'"
Stop-Service ShellHWDetection 
Write-Host 'Ok'

$vhdDriveLetter = 'X'
$vhdDriveLabel = 'SuperBatman'
$vhdsize = 1GB
Write-Host 'Creating VHD, mounting, formating and assinging letter: ' $vhdDriveLetter ' and label: ' $vhdDriveLabel
New-VHD -Path $vhdpath -Dynamic -SizeBytes $vhdsize | 
    Mount-VHD -Passthru | 
    Initialize-Disk -Passthru | 
    New-Partition <# -AssignDriveLetter #> -UseMaximumSize -DriveLetter $vhdDriveLetter | 
    Format-Volume -FileSystem FAT32 -NewFileSystemLabel $vhdDriveLabel -Confirm:$false -Force | Out-Null
Write-Host 'Ok'

Write-Host 'Starting ShellHWDetection service again'
Start-Service ShellHWDetection 
Write-Host 'Ok'



Write-Host 'Working folders'
Invoke-Expression $localPath"FileCreator.ps1 -path 'X:\MCS\' -itemCount 40 -depth 2 "
Write-Host 'Ok'





