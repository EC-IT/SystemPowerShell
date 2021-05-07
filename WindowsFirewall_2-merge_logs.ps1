# MPE - AVRIL 2021
# MERGE LOG FILES AND REMOVE DUPLIACTE LINE

# LOG FOLDER
$logdir = "C:\Temp"

# GET LOGS FILES RECEIVE AND SEND
$logfiles_RECEIVE_list = Get-ChildItem "$logdir" -Name "*RECEIVE*log"
$logfiles_SEND_list = Get-ChildItem "$logdir" -Name "*SEND*log"

# GET LOGS RECEIVE
$log_RECEIVE = @()
foreach ( $logfiles_RECEIVE in $logfiles_RECEIVE_list )
{
    $log_RECEIVE += Get-Content "${logdir}\${logfiles_RECEIVE}"
}
$log_RECEIVE_uniq = $log_RECEIVE | Sort-Object -Unique 

# GET LOGS SEND
$log_SEND = @()
foreach ( $logfiles_SEND in $logfiles_SEND_list )
{
    $log_SEND += Get-Content "${logdir}\${logfiles_SEND}"
}
$log_SEND_uniq = $log_SEND | Sort-Object -Unique 

# WRITE MERGE LOGS
$log_RECEIVE_uniq | Out-File -FilePath "${logdir}\pfirewall_RECEIVE_TOTAL.txt"
$log_SEND_uniq | Out-File -FilePath "${logdir}\pfirewall_SEND_TOTAL.txt"
