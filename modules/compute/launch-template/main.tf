# =========================================
# Launch Template
# =========================================

resource "aws_launch_template" "this" {
  name        = var.name
  description = var.description
  
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  
  vpc_security_group_ids = var.vpc_security_group_ids
  
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  
  user_data = var.user_data != null ? base64encode(var.user_data) : null
  
  monitoring {
    enabled = var.enable_monitoring
  }
  
  ebs_optimized = var.ebs_optimized
  
  # Block device mappings
  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    
    content {
      device_name = block_device_mappings.value.device_name
      
      ebs {
        volume_size           = block_device_mappings.value.ebs.volume_size
        volume_type           = block_device_mappings.value.ebs.volume_type
        delete_on_termination = block_device_mappings.value.ebs.delete_on_termination
        encrypted             = block_device_mappings.value.ebs.encrypted
      }
    }
  }
  
  # Metadata options (IMDSv2)
  metadata_options {
    http_endpoint               = var.metadata_options.http_endpoint
    http_tokens                 = var.metadata_options.http_tokens
    http_put_response_hop_limit = var.metadata_options.http_put_response_hop_limit
    instance_metadata_tags      = var.metadata_options.instance_metadata_tags
  }
  
  tag_specifications {
    resource_type = "instance"
    
    tags = merge(
      var.tags,
      {
        Name = var.name
      }
    )
  }
  
  tag_specifications {
    resource_type = "volume"
    
    tags = merge(
      var.tags,
      {
        Name = "${var.name}-volume"
      }
    )
  }
  
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
