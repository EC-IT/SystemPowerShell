# Get-ComputerInfo | select WindowsProductName, CsCaption

$computers = $(Get-ADComputer -Filter *).Name

$list = @()
foreach ( $computer in $computers )
{
    $list += Invoke-Command -ComputerName "${computer}.local" -ScriptBlock { Get-ComputerInfo | select WindowsProductName  }
}
