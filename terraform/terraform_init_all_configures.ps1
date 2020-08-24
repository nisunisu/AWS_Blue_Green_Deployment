$dir_arr=@(
  ".\tf_vpc"
  ".\tf_ec2_blue"
  ".\tf_ec2_green"
  ".\tf_ec2_bastion" # bastion must be done at the end because it manages the security groups of blue/green EC2
  ".\tf_rds"
  ".\tf_alb"
)
foreach ($dir in $dir_arr) {
  Write-Output "======"
  Push-Location
  Set-Location -Path ${dir}
  Get-Location | Format-Table -AutoSize -Wrap
  terraform init
  if ($? -ne $true) {
    Write-Output "Error"
    exit 100
  }
  Pop-Location
}