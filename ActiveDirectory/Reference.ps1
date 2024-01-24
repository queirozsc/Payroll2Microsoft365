#Retrieving a user
Get-ADUser -Filter "PostalCode -eq '11604867'" -Properties *

#Cleanup Active Directory groups
#type the adgroup name to check
$grouptoclean = "XXXXX"

####
$dcfqdn  = ((Get-ADDomainController).Hostname)

$groupmembers = Get-ADGroupMember -Server $dcfqdn -Identity $grouptoclean  | sort

$inactiveusers = @()
foreach($user in $groupmembers){

  $dist = ($user).distinguishedName
  
  $enabled = Get-ADUser -Server $dcfqdn -Identity "$dist" | Where-Object{$_.enabled -eq $false}
  $sam = ($enabled).SamAccountName
  $upn = ($enabled).UserPrincipalName
  $active = ($enabled).Enabled
  
  if($enabled){
    Write-Host "UPN: $upn , SAM: $sam is disabeld, Status: $active" -ForegroundColor Yellow
    $inactiveusers += $sam 
    Remove-ADGroupMember -Identity $grouptoclean -Members $sam -server $dcfqdn -Confirm:$false -WhatIf
    
  }
  else{
      $member = Get-ADUser -Server $dcfqdn -Identity "$dist"
      
      $sammember = ($member).SamAccountName
      $upnmember = ($member).UserPrincipalName
      $activemember = ($member).Enabled
      
    Write-Host "UPN: $upnmember, SamAccountName: $sammember Status: $activemember"
  
  } 
  
 
} 


$inactiveusers

($inactiveusers).count 

#$inactiveusers = $null

### Fill AD Groups
$files = Get-ChildItem \\dc01\adgroup\*.txt -Recurse
$adgroupprefix = "g-demo-"
## get content of every file and its name 
foreach($file in $files){
$name = ($file).Name.ToString()
$noextension = ($name.Substring(0,$name.Length-4))
$path = ($file).FullName
$adgroup = $adgroupprefix+$noextension
$samaccounts = Get-Content "$path"
Write-Host "### $adgroup ###"
### get all user from ad group and remove them
$tempmembers = Get-ADGroupmember -Identity $adgroup 
foreach($tempmember in $tempmembers){
    $name = ($tempmember).name
    Write-Host "Removing user: $name" -ForegroundColor Green
    Remove-ADGroupMember -Identity $adgroup -Members $tempmember -Confirm:$false
}
### adding all users from txt files 
foreach ($newmember in $samaccounts){
    
    Write-host "Adding $newmember to $adgroup" -ForegroundColor Green
    Add-ADGroupMember -Identity $adgroup -Members $newmember
    }
   }