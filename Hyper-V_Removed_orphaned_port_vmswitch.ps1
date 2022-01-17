# MPE - JAN 2022 - Removed Orphaned PortID
# source : http://www.kuskaya.info/2020/04/19/how-to-troubleshoot-event-id-15-from-source-hyper-v-vmswitch-failed-to-restore-configuration-for-port-xxx-on-switch-xxx-object-name-not-found/

$VMSwitchExtensionPortData = Get-VMSwitchExtensionPortData -VMName *
$switchid = $(Get-VMSwitch)[0].Id.Guid
$vmswitch_keys = Get-ChildItem -Path HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList\${switchid}

foreach ( $key in $vmswitch_keys )
{
    $vm = $VMSwitchExtensionPortData | where-object {$_.Data -like "*$($key.PSChildName)*"} | select vmname
    if ( $vm )
    {
        echo " $($vm[0].VMName)  $($key.PSChildName) "
    }
    else
    {
        if ( $($key.PSChildName) )
        {
            Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList\${switchid}\$($key.PSChildName)" -Recurse
        }
    }
}

