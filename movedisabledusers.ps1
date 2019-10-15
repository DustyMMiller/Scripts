$date = get-date -UFormat %m%d%Y%H%M
$beforecsv = $date + "-disabledusers-before.csv"
$aftercsv = $date + "-disabledusers-after.csv"
$searchbase = ''
$targetpath = ''

$userstomove = Get-ADUser -Filter 'enabled -eq "false"' -SearchBase $searchbase | Where-Object -Property DistinguishedName -NotLike '*Disabled Accounts*'

$userstomove | export-csv $beforecsv

$userstomove | Move-ADObject -TargetPath $targetpath

$afterusers = Get-ADUser -Filter 'enabled -eq "false"' -SearchBase $searchbase | Where-Object -Property DistinguishedName -NotLike '*Disabled Accounts*'

$afterusers | export-csv $aftercsv