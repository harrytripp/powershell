# get value of mail extension attribute and adds it to proxyAddress extension attribute
$ou = Get-ADUser -Filter * -SearchBase "OU=grandchild,OU=child,OU=parent,DC=network,DC=local"

foreach ($user in $ou){
    $mail = Get-ADUser -Identity $user -Properties mail | Select-Object mail
    $MailStr = "$($mail[0])"
    $trim = $MailStr.Trim("@","{","}"," ")
    $email = $trim.substring($trim.IndexOf("=") + 1)
    Set-ADUser -Identity $user -Add @{Proxyaddresses="SMTP:"+$email} -WhatIf
}
