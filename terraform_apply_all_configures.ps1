[CmdletBinding()]
param (
  [switch]$IgnoreRDS,
  [switch]$IgnoreALB
)

$dir_arr=@(
  ".\tf_vpc"
  ".\tf_ec2_blue"
  ".\tf_ec2_green"
  ".\tf_ec2_bastion" # bastion must be done at the end because it manages the security groups of blue/green EC2
)
if ($IgnoreRDS -eq $false){
  $dir_arr += ".\tf_rds"
}
if ($IgnoreALB -eq $false){
  $dir_arr += ".\tf_alb"
}
$result = $null
foreach ($dir in $dir_arr) {
  Write-Output "======"
  Push-Location
  Set-Location -Path ${dir}
  Get-Location
  terraform apply --auto-approve
  if ($? -ne $true) {
    Write-Output "Error"
    exit 100
  }
  Pop-Location
}
foreach ($dir in $dir_arr) {
  Write-Output "======"
  Push-Location
  Set-Location -Path ${dir}
  Get-Location | Format-Table -AutoSize -Wrap
  terraform output
  Pop-Location
}