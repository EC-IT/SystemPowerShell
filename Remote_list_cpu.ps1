

$computers = $(Get-ADComputer -Filter *).Name

$list = @()
foreach ( $computer in $computers )
{
    $stat = "" | Select name,cpu
    
    $stat.cpu = Invoke-Command -ComputerName "${computer}.local" -ScriptBlock { $(Get-WmiObject -Class Win32_Processor -ComputerName. | Select-Object -Property [a-z]*).Name }
    $stat.name = $computer
    $list += $stat

}
$list 