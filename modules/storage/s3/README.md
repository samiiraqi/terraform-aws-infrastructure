# S3 Bucket Module

Creates a secure S3 bucket with encryption and versioning.

## Features

- ✅ Versioning enabled by default
- ✅ Encryption at rest
- ✅ Public access blocked
- ✅ Lifecycle rules support
- ✅ Access logging support

## Usage

### Basic Bucket
```hcl
module "app_bucket" {
  source = "../../modules/storage/s3"
  
  bucket_name = "myapp-files-${random_id.suffix.hex}"
  
  versioning_enabled = true
  encryption_enabled = true
  
  tags = {
    Purpose = "Application files"
  }
}
```

### Logs Bucket
```hcl
module "logs_bucket" {
  source = "../../modules/storage/s3"
  
  bucket_name = "myapp-logs-${random_id.suffix.hex}"
  
  lifecycle_rules = [
    {
      id              = "delete-old-logs"
      enabled         = true
      expiration_days = 90
    },
    {
      id              = "archive-logs"
      enabled         = true
      transition_days = 30
      storage_class   = "GLACIER"
    }
  ]
}
```

## Best Practices

✅ Always enable versioning  
✅ Always enable encryption  
✅ Block all public access  
✅ Use lifecycle rules for cost optimization  
✅ Enable logging for audit trails
