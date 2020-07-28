# Manage EC2 AMI

# Install
- [Install Packer](https://learn.hashicorp.com/packer/getting-started/install)

# Command
```bash
packer --version
packer validate ./amazon_linux_2.json
packer build    ./amazon_linux_2.json
```

# What is contained
- `amazon_linux_2.json`
  - nginx (enabled)
  - mysql client