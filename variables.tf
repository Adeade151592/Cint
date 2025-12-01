variable "name" {
  type        = string
  default     = "cint-code-test"
  description = "Root name for resources in this project"
}

variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC cidr block"
}

variable "newbits" {
  default     = 8
  type        = number
  description = "How many bits to extend the VPC cidr block by for each subnet"
}

variable "public_subnet_count" {
  default     = 3
  type        = number
  description = "How many subnets to create"
}

variable "private_subnet_count" {
  default     = 3
  type        = number
  description = "How many private subnets to create"
}

variable "instance_type" {
  default     = "t3.micro"
  type        = string
  description = "EC2 instance type"
}

variable "db_instance_class" {
  default     = "db.t3.medium"
  type        = string
  description = "RDS instance class"
}

variable "db_name" {
  default     = "appdb"
  type        = string
  description = "Database name"
}

variable "db_username" {
  default     = "dbadmin"
  type        = string
  description = "Database username"
}

variable "min_size" {
  default     = 2
  type        = number
  description = "Minimum number of instances in ASG"
}

variable "max_size" {
  default     = 4
  type        = number
  description = "Maximum number of instances in ASG"
}

variable "environment" {
  default     = "dev"
  type        = string
  description = "Environment name"
}

variable "cpu_scale_up_threshold" {
  default     = 70
  type        = number
  description = "CPU threshold for scaling up"
}

variable "cpu_scale_down_threshold" {
  default     = 30
  type        = number
  description = "CPU threshold for scaling down"
}

variable "monthly_budget_limit" {
  default     = 150
  type        = string
  description = "Monthly budget limit in USD"
}

variable "notification_emails" {
  default     = ["admin@example.com"]
  type        = list(string)
  description = "Email addresses for budget notifications"
}

variable "db_engine_version" {
  default     = "8.0.mysql_aurora.3.04.0"
  type        = string
  description = "Aurora MySQL engine version"
}

variable "db_port" {
  default     = 3306
  type        = number
  description = "Database port"
}

variable "domain_name" {
  default     = ""
  type        = string
  description = "Domain name for SSL certificate (optional)"
}