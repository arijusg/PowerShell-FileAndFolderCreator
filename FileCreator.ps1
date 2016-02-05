param (
  [string]$path = "C:\TEST\",
  [int]$itemCount = 2,
  [int]$depth = 2
)

#$path = "C:\CUSTOMTEST\";
#Remove-Item $path'*' -recurse

function CreateFile($p)
{
    #Write-Host $p
    New-Item $p -type File -Force | Out-Null
}

function CreateFolder($p)
{
    #Write-Host $p
    New-Item $p -type Directory -Force | Out-Null
}


$fileCount = $itemCount
$reverseFileCount = $itemCount * 2
#Write-Host $reverseFileCount 

$lvl = 0
$maxLvl = $depth + 1

function CreateFilesFoldersInAscendingOrder($p)
{
    $lvl++
    if($lvl -ge $maxLvl) {return}

    for($i=1; $i -le $fileCount; $i++){
           CreateFolder($p + $i);
           CreateFile($p + $i + '.CNC');
           CreateFilesFoldersInAscendingOrder($p + $i + '\')
           CreateFilesFoldersInDescendingOrder($p + $i + '\')
    } 
}

function CreateFilesFoldersInDescendingOrder($p)
{
    $lvl++
    if($lvl -ge $maxLvl) {return}

    for($i=$reverseFileCount; $i -ge $fileCount; $i--){
           CreateFolder($p + $i);
           CreateFile($p + $i + '.CNC');
           CreateFilesFoldersInAscendingOrder($p + $i + '\')
           CreateFilesFoldersInDescendingOrder($p + $i + '\')
    }
}

CreateFilesFoldersInAscendingOrder $path;
CreateFilesFoldersInDescendingOrder $path;
