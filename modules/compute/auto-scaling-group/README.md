# Auto Scaling Group Module

Creates an Auto Scaling Group for automatic EC2 scaling.

## Features

- ✅ Automatic scaling based on demand
- ✅ Multi-AZ support
- ✅ Load balancer integration
- ✅ Health checks (EC2 and ELB)
- ✅ CloudWatch metrics
- ✅ Rolling updates support

## What is Auto Scaling?

Auto Scaling automatically:
- ✅ **Adds instances** when traffic increases
- ✅ **Removes instances** when traffic decreases
- ✅ **Replaces unhealthy** instances
- ✅ **Distributes** across AZs
- ✅ **Maintains** desired capacity

## Usage

### Basic Auto Scaling Group
```hcl
module "asg" {
  source = "../../modules/compute/auto-scaling-group"
  
  name = "web-asg"
  
  launch_template_id      = module.launch_template.launch_template_id
  launch_template_version = "$Latest"
  
  vpc_zone_identifier = [
    module.private_subnet_az1.subnet_id,
    module.private_subnet_az2.subnet_id
  ]
  
  min_size         = 2
  max_size         = 10
  desired_capacity = 2
  
  health_check_type         = "ELB"
  health_check_grace_period = 300
  
  target_group_arns = [
    module.alb.target_group_arn
  ]
  
  tags = {
    Environment = "production"
    Application = "web"
  }
}
```

### With Custom Settings
```hcl
module "asg" {
  source = "../../modules/compute/auto-scaling-group"
  
  name = "api-asg"
  
  launch_template_id = module.launch_template.launch_template_id
  
  vpc_zone_identifier = [...]
  
  min_size         = 1
  max_size         = 5
  desired_capacity = 2
  
  health_check_type         = "ELB"
  health_check_grace_period = 600  # 10 minutes
  
  termination_policies = [
    "OldestLaunchTemplate",
    "OldestInstance"
  ]
  
  default_instance_warmup = 300  # 5 minutes
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | ASG name | `string` | - | yes |
| launch_template_id | Launch template ID | `string` | - | yes |
| launch_template_version | Template version | `string` | `"$Latest"` | no |
| vpc_zone_identifier | Subnet IDs | `list(string)` | - | yes |
| min_size | Minimum instances | `number` | `1` | no |
| max_size | Maximum instances | `number` | `3` | no |
| desired_capacity | Desired instances | `number` | `2` | no |
| health_check_type | EC2 or ELB | `string` | `"ELB"` | no |
| health_check_grace_period | Grace period (seconds) | `number` | `300` | no |
| target_group_arns | ALB target groups | `list(string)` | `[]` | no |
| termination_policies | Termination order | `list(string)` | `["OldestInstance"]` | no |
| enabled_metrics | CloudWatch metrics | `list(string)` | All | no |
| default_instance_warmup | Warmup time (seconds) | `number` | `300` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling_group_id | ASG ID |
| autoscaling_group_name | ASG name |
| autoscaling_group_arn | ASG ARN |
| autoscaling_group_min_size | Min size |
| autoscaling_group_max_size | Max size |
| autoscaling_group_desired_capacity | Desired capacity |

## Health Check Types

### EC2 Health Check
```
Checks: Instance status only
Use: Simple deployments
Grace period: 300s (5 min)
```

### ELB Health Check (Recommended)
```
Checks: Instance + Load balancer health
Use: With ALB/NLB
Grace period: 300-600s
```

## Termination Policies
```
OldestInstance        - Terminate oldest
NewestInstance        - Terminate newest
OldestLaunchTemplate  - Terminate old template
ClosestToNextInstanceHour - Save cost
Default               - Balanced across AZs
```

## Scaling Scenarios

### Scenario 1: Traffic Spike
```
Normal: 2 instances
Peak:   10 instances
Auto scales up! ✅
```

### Scenario 2: Night Time
```
Day:   5 instances
Night: 2 instances
Auto scales down! ✅
```

### Scenario 3: Instance Failure
```
Desired: 3 instances
Failed:  1 instance dies
ASG:     Launches new one! ✅
```

## Best Practices

✅ Use ELB health checks with load balancer  
✅ Multi-AZ for high availability  
✅ Set appropriate grace period  
✅ Use latest launch template version  
✅ Enable CloudWatch metrics  
✅ Set min >= 2 for production  
✅ Spread across subnets (AZs)

## Multi-AZ Architecture
```
AZ-1:
  ├── Private Subnet
  └── EC2 instances (ASG)

AZ-2:
  ├── Private Subnet
  └── EC2 instances (ASG)

ASG distributes evenly!
```

## Lifecycle
```
1. Launch:
   ASG → Launch Template → EC2

2. Health Check:
   Wait grace_period → Check health

3. Unhealthy:
   Terminate → Launch new

4. Scale:
   Add/Remove based on policy
```

## CloudWatch Metrics

ASG reports:
- ✅ GroupDesiredCapacity
- ✅ GroupInServiceInstances
- ✅ GroupPendingInstances
- ✅ GroupTerminatingInstances
- ✅ GroupTotalInstances

## Cost Optimization

### Dev/Staging:
```
min_size = 1
max_size = 3
desired_capacity = 1
```

### Production:
```
min_size = 2  # HA!
max_size = 10
desired_capacity = 2
```

## Security

✅ Instances in private subnets  
✅ Use IAM roles (not access keys)  
✅ Security groups from launch template  
✅ Regular AMI updates  
✅ Encrypted EBS volumes

## Monitoring

CloudWatch metrics to watch:
- GroupInServiceInstances
- GroupTerminatingInstances
- Scaling activity logs

Set alarms on:
- Unhealthy instance count
- Failed scaling activities
