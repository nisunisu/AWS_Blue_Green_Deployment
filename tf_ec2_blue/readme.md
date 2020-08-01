# Prerequisites
- `terraform apply` in `tf_vpc/` directory has done
- keypair has created (In case that you connect to this instance via bastion(EC2))
    - procedure :
    ```PowerShell
    aws ec2 create-key-pair --key-name keypair_terraform --query 'KeyMaterial' --output text | Out-File -Encoding ascii -FilePath keypair_terraform_ec2_blue_green.pem
    ```

# Notice