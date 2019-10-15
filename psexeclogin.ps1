$date = (get-date).adddays(-60)
$computers = get-adcomputer -filter 'lastlogondate -ge $date'

$array = foreach ($computer in $computers) {
    $name = $computer.name
    $psname = "\\" + $name
    [PSCustomObject]@{
        computer = $name
	connected = (ping $name -n 1) -join '' -replace '.*Average = '
        logs = (psexec -s $psname wevtutil qe security "/q:*[System[(EventID=4624 or EventID=4625)] and EventData[Data[@Name='TargetUserName'] and ((Data='Administrator'))]]" /rd:true /f:text) -join ',' 
    }
}

$array | export-csv logincheck.csv