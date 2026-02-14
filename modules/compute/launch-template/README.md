# Launch Template Module

Creates a launch template for EC2 instances.

## Features

- ✅ Complete instance configuration
- ✅ User data support
- ✅ EBS volume configuration
- ✅ IMDSv2 enabled by default
- ✅ IAM instance profile support
- ✅ Auto Scaling compatible

## Usage

### Basic Web Server
```hcl
module "web_launch_template" {
  source = "../../modules/compute/launch-template"
  
  name        = "web-server-template"
  description = "Launch template for web servers"
  
  image_id      = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
  instance_type = "t3.micro"
  
  vpc_security_group_ids = [
    module.ec2_sg.security_group_id
  ]
  
  iam_instance_profile_name = module.ec2_role.instance_profile_name
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "Hello from $(hostname)" > /var/www/html/index.html
  EOF
  
  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = 20
        volume_type           = "gp3"
        delete_on_termination = true
        encrypted             = true
      }
    }
  ]
  
  tags = {
    Environment = "production"
    Application = "web"
  }
}
```

### With Detailed Monitoring
```hcl
module "monitored_template" {
  source = "../../modules/compute/launch-template"
  
  name              = "monitored-template"
  image_id          = "ami-xxx"
  instance_type     = "t3.small"
  enable_monitoring = true
  
  vpc_security_group_ids = [...]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Template name | `string` | - | yes |
| description | Description | `string` | `"Managed by Terraform"` | no |
| image_id | AMI ID | `string` | - | yes |
| instance_type | Instance type | `string` | `"t3.micro"` | no |
| key_name | SSH key name | `string` | `null` | no |
| vpc_security_group_ids | Security groups | `list(string)` | `[]` | no |
| iam_instance_profile_name | IAM profile | `string` | `null` | no |
| user_data | User data script | `string` | `null` | no |
| enable_monitoring | Detailed monitoring | `bool` | `false` | no |
| ebs_optimized | EBS optimization | `bool` | `true` | no |
| block_device_mappings | EBS volumes | `list(object)` | `[]` | no |
| metadata_options | Metadata config | `object` | IMDSv2 | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| launch_template_id | Launch template ID |
| launch_template_arn | Launch template ARN |
| launch_template_latest_version | Latest version |
| launch_template_name | Template name |

## Security Best Practices

### IMDSv2 (Enabled by Default)
```
Protects against SSRF attacks
Required for accessing instance metadata
```

### Encrypted EBS
```hcl
block_device_mappings = [{
  ebs = {
    encrypted = true  # Always!
  }
}]
```

### No SSH Keys in Production
```
Use SSM Session Manager instead
No key_name = no SSH access
```

## User Data Examples

### Install Apache
```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
```

### Docker Setup
```bash
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
```

### CloudWatch Agent
```bash
#!/bin/bash
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s
```

## Block Device Types
```
gp3 - General Purpose SSD (recommended, cheapest)
gp2 - General Purpose SSD (legacy)
io1 - Provisioned IOPS (high performance)
io2 - Provisioned IOPS (better)
st1 - Throughput Optimized HDD
sc1 - Cold HDD
```

## Best Practices

✅ Always use latest AMI  
✅ Enable IMDSv2  
✅ Encrypt EBS volumes  
✅ Use IAM roles, not access keys  
✅ Enable detailed monitoring for production  
✅ Use user data for bootstrapping  
✅ Version your launch templates
