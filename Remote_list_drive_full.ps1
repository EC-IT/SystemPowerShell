

$computers = $(Get-ADComputer -Filter *).Name

$list = @()
foreach ( $computer in $computers )
{
    $stat = "" | Select name,drive
    
    $stat.drive = Invoke-Command -ComputerName "${computer}.local" -ScriptBlock {
        $drives = $(Get-PSDrive  -PSProvider FileSystem).Name

        foreach ( $drive in $drives )
        {
           $p =  get-psdrive $drive | % { $_.free/($_.used + $_.free) } | % tostring p
           if ( $p -lt 10 )
           {
                echo $drive
           }
        }
      }
    $stat.name = $computer
    $list += $stat

}
$list