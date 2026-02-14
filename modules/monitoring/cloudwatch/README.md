# CloudWatch Log Group

Simple CloudWatch log group module.

## Usage
```hcl
module "logs" {
  source = "../../modules/monitoring/cloudwatch"
  
  log_group_name    = "/aws/app/myapp"
  retention_in_days = 7
}
```
