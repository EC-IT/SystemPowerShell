# MPE - MAI 2021
# https://maliyaablog.wordpress.com/2017/10/02/how-to-createwrite-and-save-excel-using-powershell/

$dirlogs = "C:\Temp\logs\"
$fileslist = Get-ChildItem $dirlogs -Filter *RECEIVE*rules.txt

# NEW EXCEL
$excel = New-Object -ComObject excel.application
$workbook = $excel.Workbooks.Add()

$feuille=0
foreach( $file in $fileslist )
{
    $server = $file.BaseName.split("_")[0]
    $rules = Get-Content $file.FullName

    $diskSpacewksht= $workbook.Worksheets.Add()
    $diskSpacewksht.Name = $server

    # HEADERS
    $diskSpacewksht.Cells.Item(2,8) = "$server Inbound"
    $diskSpacewksht.Cells.Item(3,1) = 'SOURCE'
    $diskSpacewksht.Cells.Item(3,2) = 'DESTINATION'
    $diskSpacewksht.Cells.Item(3,3) = 'PORT'
    
    $diskSpacewksht.Cells.Item(3,1).ColumnWidth = 23;
    $diskSpacewksht.Cells.Item(3,2).ColumnWidth = 23;
    $diskSpacewksht.Cells.Item(3,3).ColumnWidth = 23;

    # DATA
    $col = 4
    foreach( $rule in $rules)
    {
        $source = $rule.split(" ")[0]
        $port = $rule.split(" ")[1]
        $destination = $server
        
        $ports = $port.split(",")
        foreach($p in $ports)
        {
            $diskSpacewksht.Cells.Item($col,1) = $source
            $diskSpacewksht.Cells.Item($col,2) = $destination
            $diskSpacewksht.Cells.Item($col,3) = $p
            $col++
        }
    }
}

# SAVE EXCEL
$excel.DisplayAlerts = 'False'
$ext=".xlsx"
$path=$dirlogs + "Firewall_rules_inbound$ext"
$workbook.SaveAs($path) 
$workbook.Close
$excel.DisplayAlerts = 'False'
$excel.Quit()

