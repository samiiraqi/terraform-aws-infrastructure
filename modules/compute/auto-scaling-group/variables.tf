# =========================================
# Auto Scaling Group Variables
# =========================================

variable "name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "launch_template_id" {
  description = "ID of the launch template"
  type        = string
}

variable "launch_template_version" {
  description = "Launch template version ($Latest, $Default, or version number)"
  type        = string
  default     = "$Latest"
}

variable "vpc_zone_identifier" {
  description = "List of subnet IDs to launch instances in"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "health_check_type" {
  description = "Health check type (EC2 or ELB)"
  type        = string
  default     = "ELB"
  
  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "Must be EC2 or ELB"
  }
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "target_group_arns" {
  description = "List of target group ARNs for load balancer"
  type        = list(string)
  default     = []
}

variable "termination_policies" {
  description = "Termination policies"
  type        = list(string)
  default     = ["OldestInstance"]
}

variable "enabled_metrics" {
  description = "CloudWatch metrics to enable"
  type        = list(string)
  default = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
}

variable "wait_for_capacity_timeout" {
  description = "Timeout for waiting for capacity"
  type        = string
  default     = "10m"
}

variable "default_instance_warmup" {
  description = "Default instance warmup time in seconds"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
