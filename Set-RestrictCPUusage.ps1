# MPE - 2019

# Limit CPU usage
function Set-RestrictCPUusage()
{
	$LogicalProcessors = (Get-WmiObject –class Win32_processor -Property NumberOfLogicalProcessors).NumberOfLogicalProcessors;

	if ( $LogicalProcessors -gt 2 )
	{
		$workcore = ($LogicalProcessors - 2)
		$halfmask = [convert]::ToString(([math]::pow(2,$workcore) )-1, 2)
		$halfaffinity = [convert]::ToInt32($halfmask, 2)

		# recupere le process qui utilise le plus le CPU
		$process_big = $(Get-Process | Sort CPU -descending )[0]  

		# Si le CPU est utilisé a plus de 80%...
		if ( $cpu_percent -gt 80 )
		{
			# ...ALORS le process qui l'utilise plus est limité à 50%
			$process_big.ProcessorAffinity=$halfaffinity
		}
	}
}
