# MPE - AVRIL 2021
# COPY FIREWALL LOGS AND REMOVE DUPLICATE LINE

$logfile = "C:\Windows\System32\LogFiles\firewall\pfirewall.log"
$dir_result = "C:\Temp"
$jour = Get-Date -Format "yyyyMMdd"

# GET LOGS
$textlogs = Get-Content $logfile | Where { $_ -notmatch "^#" }
$textlogs_RECEIVE = $textlogs | Where { $_ -match "RECEIVE$" -and $_ -notmatch '127.0.0.1' }
$textlogs_SEND = $textlogs | Where { $_ -match "SEND$" -and $_ -notmatch '127.0.0.1' }

# KEEP SOURCE - PORT
$logs_list_RECEIVE = @()
foreach( $textlog in $textlogs_RECEIVE)
{

    $log_texte = $textlog.split(" ")[4] + " " + $textlog.split(" ")[7]
    $logs_list_RECEIVE += $log_texte
}
$logs_uniq_RECEIVE = $logs_list_RECEIVE | Sort-Object -Unique

# KEEP DESTINATION - PORT
$logs_list_SEND = @()
foreach( $textlog in $textlogs_SEND)
{
    $log_texte = $textlog.split(" ")[5] + " " + $textlog.split(" ")[7]
    $logs_list_SEND += $log_texte
}
$logs_uniq_SEND = $logs_list_SEND | Sort-Object -Unique

# SAVE
$logs_uniq_RECEIVE | Out-File -FilePath "${dir_result}\pfirewall_RECEIVE_unique_${jour}.log" 
$logs_uniq_SEND | Out-File -FilePath "${dir_result}\pfirewall_SEND_unique_${jour}.log" 

