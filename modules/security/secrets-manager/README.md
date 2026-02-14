# Secrets Manager Module

Creates and manages secrets in AWS Secrets Manager.

## Features

- ✅ Secure secret storage
- ✅ Automatic rotation support
- ✅ KMS encryption
- ✅ Recovery window protection

## Usage

### Database Password
```hcl
module "db_password" {
  source = "../../modules/security/secrets-manager"
  
  name        = "rds/myapp/master-password"
  description = "RDS master password"
  
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db.result
  })
  
  recovery_window_in_days = 30
}
```

### API Key
```hcl
module "api_key" {
  source = "../../modules/security/secrets-manager"
  
  name = "app/external-api/key"
  
  secret_string = jsonencode({
    api_key = var.api_key
  })
}
```

## Best Practices

✅ Use for all sensitive data  
✅ Never commit secrets to Git  
✅ Enable automatic rotation  
✅ Use IAM roles for access  
✅ Enable recovery window
