$date = get-date -UFormat %m%d%Y%H%M
$beforecsv = $date + "-disabledusersgroups-before.csv"
$aftercsv = $date + "-disabledusersgroups-after.csv"

$disabledusers = Get-ADUser -Filter 'enabled -eq "False"' -SearchBase 'OU=Disabled Accounts,OU=Facilities-OLD,DC=hcmg,DC=com'-properties Description


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
    foreach ($group in $groups) {
        if($group.name -ne "Domain Users") {
            $updateduser = get-aduser $user -properties Description
            $description = $updateduser.Description + ' ; ' + $group.name
            Set-ADUser -Identity $user -Description $description
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
