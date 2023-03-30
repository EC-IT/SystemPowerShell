

$computers = $(Get-ADComputer -Filter *).Name

$list = @()
foreach ( $computer in $computers )
{
    $stat = "" | Select name,date
    
    $stat.date = Invoke-Command -ComputerName "${computer}.local" -ScriptBlock { $(gwmi win32_quickfixengineering |sort installedon -desc )[0].InstalledOn.ToString("dd-MM-yyyy") }
    $stat.name = $computer
    $list += $stat

}
$list 