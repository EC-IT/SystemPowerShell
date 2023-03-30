

$computers = $(Get-ADComputer -Filter *).Name

$list = @()
foreach ( $computer in $computers )
{
    $stat = "" | Select name,share
    
    $stat.share = Invoke-Command -ComputerName "${computer}.local" -ScriptBlock { $(Get-SmbShare -Special $false | ForEach-Object { Get-SmbShareAccess $_.Name } | where { $_.AccountName -eq "Everyone" } ).Name }
    $stat.name = $computer
    $list += $stat

}
$list 
