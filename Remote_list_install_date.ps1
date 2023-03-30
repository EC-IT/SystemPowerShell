

$computers = $(Get-ADComputer -Filter *).Name

$list = @()
foreach ( $computer in $computers )
{
    $stat = "" | Select name,date
    
    $stat.date = Invoke-Command -ComputerName "${computer}.local" -ScriptBlock { $(gcim Win32_OperatingSystem | select Version, InstallDate, OSArchitecture).InstallDate }
    $stat.name = $computer
    $list += $stat

}
$list 