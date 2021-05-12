# MPE - AVRIL/MAI 2021
# GENERATE FLOW MATRIX FROM LOGS

$dirlogs = "C:\Temp\logs\"
$fileslist = Get-ChildItem $dirlogs -Filter *SEND*TOTAL.txt

$subnets = @() 
$subnets += , ("subnet1","10.10.0.0/16","^10\.10")
$subnets += , ("subnet2","172.16.0.0/24","^172\.16")
$subnets += , ("port_web","0.0.0.0/0"," (80|443)$")

foreach ( $file in $fileslist)
{
    echo $file.FullName
    $files = $file.FullName
    $pfirewall= Get-Content $files  | Where { $_ -notmatch "^(::|169\.254)" }
    $rules_files = $dirlogs + [io.path]::GetFileNameWithoutExtension($files) + ".rules.txt"

    $rules_list = @()
    foreach ( $subnet in $subnets )
    {
        $regex = $subnet[2]
        $range = $subnet[1]

        # FLUX SPECIFIC 
        $pfirewall_subnet = $pfirewall | ? { $_ -match $regex  }        
        if ($pfirewall_subnet.Count -gt 0 )
        {
            $pfirewall_subnet_port = $pfirewall_subnet | ForEach-Object{($_ -split "\s+")[1]} | sort -Unique    
            $listport = $pfirewall_subnet_port -join ',';
            $rules_list += "$range $listport"
        }
    }
    
    # AUTRES FLUX 
    $pfirewall_temp =  $pfirewall
    foreach ( $subnet in $subnets )
    {
        $regex = $subnet[2]
        $pfirewall_temp = $pfirewall_temp | ? { $_ -notmatch $regex }
    }
    $rules_list += $pfirewall_temp

    $rules_list | Out-File $rules_files
}
