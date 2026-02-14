# =========================================
# Auto Scaling Group
# =========================================

resource "aws_autoscaling_group" "this" {
  name = var.name
  
  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }
  
  vpc_zone_identifier = var.vpc_zone_identifier
  
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  
  target_group_arns = var.target_group_arns
  
  termination_policies = var.termination_policies
  
  enabled_metrics = var.enabled_metrics
  
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  
  default_instance_warmup = var.default_instance_warmup
  
  dynamic "tag" {
    for_each = merge(
      var.tags,
      {
        Name = var.name
      }
    )
    
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
