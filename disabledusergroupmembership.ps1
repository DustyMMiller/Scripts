$date = get-date -UFormat %m%d%Y%H%M
$beforecsv = $date + "-disabledusersgroups-before.csv"
$aftercsv = $date + "-disabledusersgroups-after.csv"
$searchbase = ''

$disabledusers = Get-ADUser -Filter 'enabled -eq "False"' -SearchBase $searchbase

$array = foreach ($user in $disabledusers) {
    $groups = Get-ADPrincipalGroupMembership -Identity $user
    [PSCustomObject]@{
        user = $user.samaccountname
        name = $user.name
        groups = $groups.name -join ','
    }
}
$array | export-csv $beforecsv


foreach ($user in $disabledusers) {
    $groups = Get-ADPrincipalGroupMembership -Identity $user
    $groupnames = $groups.name -join ','
    Set-ADUser -Identity $user -Description $groupnames
    foreach ($group in $groups) {
        if($group.name -ne "Domain Users") {
            Remove-ADPrincipalGroupMembership -Identity $user -MemberOf $group -Confirm:$false
        }
    }
}


$array = foreach ($user in $disabledusers) {
    $groups = Get-ADPrincipalGroupMembership -Identity $user
    [PSCustomObject]@{
        user = $user.samaccountname
        name = $user.name
        groups = $groups.name -join ','
    }
}

$array | export-csv $aftercsv