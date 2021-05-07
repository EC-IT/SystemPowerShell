# MPE - 14 jan 2021

$LogicalProcessors = (Get-WmiObject –class Win32_processor -Property NumberOfLogicalProcessors).NumberOfLogicalProcessors;
$halfcore = ($LogicalProcessors / 2)
$halfmask = [convert]::ToString(([math]::pow(2,$halfcore) )-1, 2)
$halfaffinity = [convert]::ToInt32($halfmask, 2)


$Process = Get-Process httpd, java


foreach ( $p in $Process)
{
    $p.PriorityClass="IDLE"
    $p.ProcessorAffinity=$halfaffinity
}
