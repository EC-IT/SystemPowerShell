# MPE - 04 fev 2020

# Find user domain 
function Get-UserDomain()
{
    param( $nom )

    $gcsrv = Get-ADForest | Select-Object -ExpandProperty GlobalCatalogs | Select-Object -Last 1
    $domains= Get-ADTrust -Filter * -Server "$($gcsrv):3268" | select -ExpandProperty Name | Sort-Object | Get-Unique
    $dcs = foreach ($domain in $domains){(Get-ADDomainController -DomainName $domain -Discover -Service ADWS -ErrorAction SilentlyContinue | select -First 1).hostname}
    foreach ($dc in $dcs) { if ($dc) { Get-ADUser -Identity $nom -Server $dc -ErrorAction SilentlyContinue } }
}

