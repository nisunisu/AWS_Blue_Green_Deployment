# bastionより先にblueを消そうとすると処理が終わらない問題の回避が必要
$dir_arr=@(
  ".\tf_alb"
  ".\tf_rds"
  ".\tf_ec2_bastion"
  ".\tf_ec2_blue"
  ".\tf_ec2_green"
  ".\tf_vpc"
)
foreach ($dir in $dir_arr) {
  Write-Output "======"
  Push-Location
  Set-Location -Path ${dir}
  Get-Location | Format-Table -AutoSize -Wrap
  
  # destory only when resource exists
  $stat = terraform state list
  if ( ($stat | Measure-Object).count -ne 0 ) {
    terraform destroy --auto-approve | Out-Null
    if ($? -ne $true) {
      Write-Output "Error"
      exit 100
    }
  }
  Pop-Location
}