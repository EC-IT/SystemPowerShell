# MPE - juillet 2019

# Genere le mask affinity pour 50% du CPU ( Formule : (2^(LogicalProcessors / 2)) -1 )
$LogicalProcessors = (Get-WmiObject –class Win32_processor -Property NumberOfLogicalProcessors).NumberOfLogicalProcessors;
$halfcore = ($LogicalProcessors / 2)
$halfmask = [convert]::ToString(([math]::pow(2,$halfcore) )-1, 2)
$halfaffinity = [convert]::ToInt32($halfmask, 2)


# recupere l'utilisation du CPU
$cpu_percent = $(Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average).Average

# recupere le process qui utilise le plus le CPU
$process_big = $(Get-Process | Sort CPU -descending )[0]

# Si le CPU est utilisé a plus de 80%...
if ( $cpu_percent -gt 60 )
{
    # ...ALORS le process qui l'utilise plus est limité à 50%
    $process_big.ProcessorAffinity=$halfaffinity
	$process_big.PriorityClass="IDLE"
}
