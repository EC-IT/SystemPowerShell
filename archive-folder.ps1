# MPE - NOV 2019

# Zip file oder than 1 month
function archive-folder()
{
    param ( $dossier )

	if ( $dossier )
	{
		$lastmonth=(Get-Date -day 1 -hour 0 -minute 0 -second 0).AddDays(-1)
		$dossierdate = $lastmonth.ToString("yyyyMM")

		New-Item -ItemType directory -Path "$dossier\$dossierdate"
		get-childitem -Path "$dossier\*log*" | where-object {$_.LastWriteTime -lt $lastmonth} | move-item -destination "$dossier\$dossierdate"

		# zip folder
		Add-Type -assembly "system.io.compression.filesystem"
		[io.compression.zipfile]::CreateFromDirectory("$dossier\$dossierdate", "$dossier\$dossierdate.zip") 

		# suppression du dossier
		if (Test-Path "$dossier\$dossierdate.zip") 
		{
			Remove-Item "$dossier\$dossierdate" -Recurse -Force
		}
	}
}

