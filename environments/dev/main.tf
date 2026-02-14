# =========================================
# Data Sources
# =========================================

data "aws_route53_zone" "main" {
  count = var.route53_zone_id != "" ? 0 : 1
  name  = var.domain_name
}

# =========================================
# Random Resources
# =========================================

resource "random_id" "suffix" {
  byte_length = 4
}

resource "random_password" "db_password" {
  length  = 32
  special = true
}

# =========================================
# VPC
# =========================================

module "vpc" {
  source = "../../modules/networking/vpc"
  
  vpc_name = "${var.project_name}-${var.environment}-vpc"
  vpc_cidr = var.vpc_cidr
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# =========================================
# Subnets - Public
# =========================================

module "public_subnet_az1" {
  source = "../../modules/networking/subnet"
  
  vpc_id            = module.vpc.vpc_id
  subnet_name       = "${var.project_name}-${var.environment}-public-az1"
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zones[0]
  
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-az1"
    Tier = "Public"
  }
}

module "public_subnet_az2" {
  source = "../../modules/networking/subnet"
  
  vpc_id            = module.vpc.vpc_id
  subnet_name       = "${var.project_name}-${var.environment}-public-az2"
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zones[1]
  
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-az2"
    Tier = "Public"
  }
}

# =========================================
# Subnets - Private (App)
# =========================================

module "private_subnet_az1" {
  source = "../../modules/networking/subnet"
  
  vpc_id            = module.vpc.vpc_id
  subnet_name       = "${var.project_name}-${var.environment}-private-az1"
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.availability_zones[0]
  
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.project_name}-${var.environment}-private-az1"
    Tier = "Private"
  }
}

module "private_subnet_az2" {
  source = "../../modules/networking/subnet"
  
  vpc_id            = module.vpc.vpc_id
  subnet_name       = "${var.project_name}-${var.environment}-private-az2"
  cidr_block        = "10.0.12.0/24"
  availability_zone = var.availability_zones[1]
  
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.project_name}-${var.environment}-private-az2"
    Tier = "Private"
  }
}

# =========================================
# Subnets - Database
# =========================================

module "db_subnet_az1" {
  source = "../../modules/networking/subnet"
  
  vpc_id            = module.vpc.vpc_id
  subnet_name       = "${var.project_name}-${var.environment}-db-az1"
  cidr_block        = "10.0.21.0/24"
  availability_zone = var.availability_zones[0]
  
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-az1"
    Tier = "Database"
  }
}

module "db_subnet_az2" {
  source = "../../modules/networking/subnet"
  
  vpc_id            = module.vpc.vpc_id
  subnet_name       = "${var.project_name}-${var.environment}-db-az2"
  cidr_block        = "10.0.22.0/24"
  availability_zone = var.availability_zones[1]
  
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-az2"
    Tier = "Database"
  }
}

# =========================================
# Internet Gateway
# =========================================

module "igw" {
  source = "../../modules/networking/internet-gateway"
  
  vpc_id   = module.vpc.vpc_id
  igw_name = "${var.project_name}-${var.environment}-igw"
  
  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# =========================================
# NAT Gateway
# =========================================

module "nat_gateway_az1" {
  source = "../../modules/networking/nat-gateway"
  
  nat_name   = "${var.project_name}-${var.environment}-nat-az1"
  subnet_id  = module.public_subnet_az1.subnet_id
  create_eip = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-nat-az1"
  }
}

# =========================================
# Route Tables
# =========================================

# Public Route Table
module "public_route_table" {
  source = "../../modules/networking/route-table"
  
  vpc_id           = module.vpc.vpc_id
  route_table_name = "${var.project_name}-${var.environment}-public-rt"
  
  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.igw.igw_id
    }
  ]
  
  subnet_ids = [
    module.public_subnet_az1.subnet_id,
    module.public_subnet_az2.subnet_id
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
    Tier = "Public"
  }
}

# Private Route Table AZ1
module "private_route_table_az1" {
  source = "../../modules/networking/route-table"
  
  vpc_id           = module.vpc.vpc_id
  route_table_name = "${var.project_name}-${var.environment}-private-rt-az1"
  
  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.nat_gateway_az1.nat_gateway_id
    }
  ]
  
  subnet_ids = [
    module.private_subnet_az1.subnet_id
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-az1"
    Tier = "Private"
  }
}

# Private Route Table AZ2 (shares NAT from AZ1 for cost)
module "private_route_table_az2" {
  source = "../../modules/networking/route-table"
  
  vpc_id           = module.vpc.vpc_id
  route_table_name = "${var.project_name}-${var.environment}-private-rt-az2"
  
  routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.nat_gateway_az1.nat_gateway_id
    }
  ]
  
  subnet_ids = [
    module.private_subnet_az2.subnet_id
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-az2"
    Tier = "Private"
  }
}

# Database Route Table (no internet)
module "db_route_table" {
  source = "../../modules/networking/route-table"
  
  vpc_id           = module.vpc.vpc_id
  route_table_name = "${var.project_name}-${var.environment}-db-rt"
  
  routes = []  # No internet access!
  
  subnet_ids = [
    module.db_subnet_az1.subnet_id,
    module.db_subnet_az2.subnet_id
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-rt"
    Tier = "Database"
  }
}

# =========================================
# Security Groups
# =========================================

# ALB Security Group
module "alb_sg" {
  source = "../../modules/networking/security-group"
  
  vpc_id      = module.vpc.vpc_id
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for ALB"
  
  ingress_rules = [
    {
      description = "HTTP from internet"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS from internet"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

# EC2 Security Group
module "ec2_sg" {
  source = "../../modules/networking/security-group"
  
  vpc_id      = module.vpc.vpc_id
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Security group for EC2 instances"
  
  ingress_rules = [
    {
      description              = "HTTP from ALB"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-sg"
  }
}

# RDS Security Group
module "rds_sg" {
  source = "../../modules/networking/security-group"
  
  vpc_id      = module.vpc.vpc_id
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS"
  
  ingress_rules = [
    {
      description              = "MySQL from EC2"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    }
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}

# VPC Endpoints Security Group
module "vpc_endpoints_sg" {
  source = "../../modules/networking/security-group"
  
  vpc_id      = module.vpc.vpc_id
  name        = "${var.project_name}-${var.environment}-vpce-sg"
  description = "Security group for VPC Endpoints"
  
  ingress_rules = [
    {
      description = "HTTPS from VPC"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
    }
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-vpce-sg"
  }
}

# =========================================
# VPC Endpoints
# =========================================

# S3 Endpoint (Gateway - FREE!)
module "s3_endpoint" {
  source = "../../modules/networking/vpc-endpoint"
  
  vpc_id            = module.vpc.vpc_id
  service_name      = "s3"
  vpc_endpoint_type = "Gateway"
  
  route_table_ids = [
    module.private_route_table_az1.route_table_id,
    module.private_route_table_az2.route_table_id
  ]
  
  tags = {
    Name    = "${var.project_name}-${var.environment}-s3-endpoint"
    Service = "S3"
  }
}

# Secrets Manager Endpoint
module "secrets_endpoint" {
  source = "../../modules/networking/vpc-endpoint"
  
  vpc_id            = module.vpc.vpc_id
  service_name      = "secretsmanager"
  vpc_endpoint_type = "Interface"
  
  subnet_ids = [
    module.private_subnet_az1.subnet_id,
    module.private_subnet_az2.subnet_id
  ]
  
  security_group_ids = [
    module.vpc_endpoints_sg.security_group_id
  ]
  
  private_dns_enabled = true
  
  tags = {
    Name    = "${var.project_name}-${var.environment}-secrets-endpoint"
    Service = "SecretsManager"
  }
}

# CloudWatch Logs Endpoint
module "logs_endpoint" {
  source = "../../modules/networking/vpc-endpoint"
  
  vpc_id            = module.vpc.vpc_id
  service_name      = "logs"
  vpc_endpoint_type = "Interface"
  
  subnet_ids = [
    module.private_subnet_az1.subnet_id,
    module.private_subnet_az2.subnet_id
  ]
  
  security_group_ids = [
    module.vpc_endpoints_sg.security_group_id
  ]
  
  private_dns_enabled = true
  
  tags = {
    Name    = "${var.project_name}-${var.environment}-logs-endpoint"
    Service = "CloudWatchLogs"
  }
}

# =========================================
# S3 Buckets
# =========================================

# Logs Bucket
module "logs_bucket" {
  source = "../../modules/storage/s3"
  
  bucket_name = "${var.project_name}-${var.environment}-logs-${random_id.suffix.hex}"
  
  versioning_enabled = false
  encryption_enabled = true
  
  lifecycle_rules = [
    {
      id              = "delete-old-logs"
      enabled         = true
      expiration_days = 90
    }
  ]
  
  tags = {
    Name    = "${var.project_name}-${var.environment}-logs"
    Purpose = "Logs"
  }
}

# Application Files Bucket
module "app_bucket" {
  source = "../../modules/storage/s3"
  
  bucket_name = "${var.project_name}-${var.environment}-app-${random_id.suffix.hex}"
  
  versioning_enabled = true
  encryption_enabled = true
  
  tags = {
    Name    = "${var.project_name}-${var.environment}-app"
    Purpose = "Application"
  }
}

# =========================================
# Secrets Manager
# =========================================

module "db_secret" {
  source = "../../modules/security/secrets-manager"
  
  name        = "${var.project_name}/${var.environment}/rds/master"
  description = "RDS master password"
  
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    engine   = "mysql"
    host     = module.rds.db_instance_address
    port     = module.rds.db_instance_port
    dbname   = var.db_name
  })
  
  recovery_window_in_days = 7
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-secret"
  }
  
  depends_on = [module.rds]
}

# =========================================
# CloudWatch Log Groups
# =========================================

module "app_logs" {
  source = "../../modules/monitoring/cloudwatch"
  
  log_group_name    = "/aws/${var.project_name}/${var.environment}/app"
  retention_in_days = 7
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-app-logs"
    Application = var.project_name
  }
}

module "alb_logs" {
  source = "../../modules/monitoring/cloudwatch"
  
  log_group_name    = "/aws/${var.project_name}/${var.environment}/alb"
  retention_in_days = 14
  
  tags = {
    Name = "${var.project_name}-${var.environment}-alb-logs"
  }
}

module "vpc_flow_logs" {
  source = "../../modules/monitoring/cloudwatch"
  
  log_group_name    = "/aws/${var.project_name}/${var.environment}/vpc-flow"
  retention_in_days = 30
  
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc-flow-logs"
  }
}

# =========================================
# RDS Database
# =========================================

module "rds" {
  source = "../../modules/database/rds"
  
  identifier = "${var.project_name}-${var.environment}-db"
  
  engine         = "mysql"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true
  
  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result
  
  vpc_security_group_ids = [
    module.rds_sg.security_group_id
  ]
  
  subnet_ids = [
    module.db_subnet_az1.subnet_id,
    module.db_subnet_az2.subnet_id
  ]
  
  multi_az                = false  # Dev environment
  publicly_accessible     = false
  backup_retention_period = 7
  deletion_protection     = false  # Dev can be deleted
  skip_final_snapshot     = true   # Dev
  
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}

# =========================================
# IAM Role for EC2
# =========================================

module "ec2_role" {
  source = "../../modules/iam/role"
  
  role_name = "${var.project_name}-${var.environment}-ec2-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  
  inline_policies = {
    "S3Access" = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:ListBucket"
          ]
          Resource = [
            module.app_bucket.bucket_arn,
            "${module.app_bucket.bucket_arn}/*"
          ]
        }
      ]
    })
    "SecretsAccess" = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "secretsmanager:GetSecretValue"
          ]
          Resource = module.db_secret.secret_arn
        }
      ]
    })
  }
  
  create_instance_profile = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  }
}

# =========================================
# Launch Template
# =========================================

module "launch_template" {
  source = "../../modules/compute/launch-template"
  
  name        = "${var.project_name}-${var.environment}-lt"
  description = "Launch template for web servers"
  
  image_id      = var.ami_id
  instance_type = var.instance_type
  
  vpc_security_group_ids = [
    module.ec2_sg.security_group_id
  ]
  
  iam_instance_profile_name = module.ec2_role.instance_profile_name
  
  user_data = <<-EOF
    #!/bin/bash
    # Update system
    yum update -y
    
    # Install Nginx
    amazon-linux-extras install -y nginx1
    
    # Install CloudWatch Agent
    wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
    rpm -U ./amazon-cloudwatch-agent.rpm
    
    # Create simple webpage
    cat > /usr/share/nginx/html/index.html << 'HTML'
    <!DOCTYPE html>
    <html>
    <head>
        <title>mywebsitehosting.net</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 20px;
            }
            .container {
                background: rgba(255, 255, 255, 0.95);
                padding: 60px 40px;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                max-width: 800px;
                width: 100%;
                text-align: center;
            }
            h1 { 
                font-size: 3.5em; 
                margin-bottom: 20px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }
            .subtitle {
                font-size: 1.3em;
                color: #555;
                margin-bottom: 30px;
            }
            .hostname { 
                background: #f0f0f0;
                padding: 20px;
                border-radius: 10px;
                margin: 30px 0;
                font-family: 'Courier New', monospace;
                color: #333;
            }
            .features {
                text-align: left;
                display: inline-block;
                margin-top: 30px;
            }
            .feature {
                padding: 10px 0;
                font-size: 1.1em;
                color: #444;
            }
            .feature::before {
                content: "✅ ";
                margin-right: 10px;
            }
            .powered-by {
                margin-top: 40px;
                padding-top: 20px;
                border-top: 2px solid #e0e0e0;
                color: #888;
                font-size: 0.9em;
            }
            .nginx-logo {
                color: #009639;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🚀 mywebsitehosting.net</h1>
            <p class="subtitle">Production-Ready AWS Infrastructure</p>
            
            <div class="hostname">
                <strong>Server Instance:</strong> $(hostname)<br>
                <strong>Date:</strong> $(date)
            </div>
            
            <div class="features">
                <div class="feature">Multi-AZ High Availability</div>
                <div class="feature">Auto Scaling Enabled</div>
                <div class="feature">Application Load Balancer</div>
                <div class="feature">RDS MySQL Database</div>
                <div class="feature">VPC Endpoints (Private)</div>
                <div class="feature">CloudWatch Monitoring</div>
                <div class="feature">Encrypted at Rest</div>
                <div class="feature">Secrets Manager Integration</div>
            </div>
            
            <div class="powered-by">
                Powered by <span class="nginx-logo">Nginx</span> on AWS<br>
                Built with Terraform
            </div>
        </div>
    </body>
    </html>
    HTML
    
    # Health check endpoint
    echo "OK" > /usr/share/nginx/html/health
    
    # Configure Nginx
    cat > /etc/nginx/nginx.conf << 'NGINX'
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log;
    pid /run/nginx.pid;

    events {
        worker_connections 1024;
    }

    http {
        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile            on;
        tcp_nopush          on;
        tcp_nodelay         on;
        keepalive_timeout   65;
        types_hash_max_size 4096;
        
        gzip on;
        gzip_types text/plain text/css application/json application/javascript text/xml application/xml;

        include             /etc/nginx/mime.types;
        default_type        application/octet-stream;

        server {
            listen       80 default_server;
            listen       [::]:80 default_server;
            server_name  _;
            root         /usr/share/nginx/html;

            location / {
                try_files $uri $uri/ =404;
            }
            
            location /health {
                access_log off;
                return 200 "OK";
                add_header Content-Type text/plain;
            }
        }
    }
    NGINX
    
    # Start Nginx
    systemctl start nginx
    systemctl enable nginx
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
  
  enable_monitoring = false  # Dev
  
  tags = {
    Name = "${var.project_name}-${var.environment}-lt"
  }
}

# =========================================
# Application Load Balancer
# =========================================

module "alb" {
  source = "../../modules/compute/alb"
  
  name = "${var.project_name}-${var.environment}-alb"
  
  internal        = false
  security_groups = [module.alb_sg.security_group_id]
  
  subnets = [
    module.public_subnet_az1.subnet_id,
    module.public_subnet_az2.subnet_id
  ]
  
  vpc_id              = module.vpc.vpc_id
  target_group_name   = "${var.project_name}-${var.environment}-tg"
  target_group_port   = 80
  target_group_protocol = "HTTP"
  
  listener_port     = 80
  listener_protocol = "HTTP"
  
  health_check = {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  
  enable_deletion_protection = false  # Dev
  
  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

# =========================================
# Auto Scaling Group
# =========================================

module "asg" {
  source = "../../modules/compute/auto-scaling-group"
  
  name = "${var.project_name}-${var.environment}-asg"
  
  launch_template_id      = module.launch_template.launch_template_id
  launch_template_version = "$Latest"
  
  vpc_zone_identifier = [
    module.private_subnet_az1.subnet_id,
    module.private_subnet_az2.subnet_id
  ]
  
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  
  health_check_type         = "ELB"
  health_check_grace_period = 300
  
  target_group_arns = [
    module.alb.target_group_arn
  ]
  
  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-asg"
    Environment = var.environment
  }
}
