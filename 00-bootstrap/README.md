# Bootstrap - Terraform State Infrastructure

This directory creates the foundational infrastructure for Terraform state management.

## 📦 What it creates

- **S3 Bucket**: Stores Terraform state files
  - Versioning enabled (keeps 90 days of old versions)
  - Encryption enabled (AES256)
  - Public access blocked
  
- **DynamoDB Table**: Provides state locking
  - Prevents concurrent Terraform runs
  - Pay-per-request billing

## 🚀 Usage

### First time setup
```bash
cd 00-bootstrap
terraform init
terraform plan
terraform apply
```

### ⚠️ Important Notes

1. **Run only once**: This creates shared infrastructure
2. **State is local**: Bootstrap state is stored locally (backup it!)
3. **No backend**: Bootstrap cannot use S3 backend (chicken-egg problem)

## 🔄 Outputs

After applying, you'll get:
- S3 bucket name
- DynamoDB table name
- Backend configuration for other environments

## 🗑️ Cleanup
```bash
# Only run if you want to destroy everything!
terraform destroy
```

⚠️ **Warning**: Destroying this will make other environments unable to access their state!
