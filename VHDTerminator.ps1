function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}
$localPath = (Get-ScriptDirectory) + '\'

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