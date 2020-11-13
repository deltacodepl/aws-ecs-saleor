variable "region" {
  description = "The AWS region"
  default     = "us-west-1"
}

# networking

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b"]
}

# ecs

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "production"
}

# AMI with ECS controller
variable "amis" {
  description = "AMI"
  default = {
    us-west-1 = "ami-009091e3f87715508"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "docker_image_url_django" {
  description = "Docker image to run in the ECS cluster"
  default     = "<ID>.dkr.ecr.us-west-1.amazonaws.com/saleor:latest"
}

variable "docker_image_url_nginx" {
  description = "Docker image to run in the ECS cluster"
  default     = "<ID>.dkr.ecr.us-west-1.amazonaws.com/nginx:latest"
}

variable "app_count" {
  description = "Number of Docker containers to run"
  default     = 2
}

variable "allowed_hosts" {
  description = "Domain name for allowed hosts"
  default     = "production-alb-871868843.us-west-1.elb.amazonaws.com"
}

# logs

variable "log_retention_in_days" {
  default = 30
}

# key pair

variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

# auto scaling

variable "autoscale_min" {
  description = "Minimum number of EC2"
  default     = "1"
}
variable "autoscale_max" {
  description = "Maximum number of EC2"
  default     = "2"
}
variable "autoscale_desired" {
  description = "Desired number of EC2"
  default     = "2"
}

# rds

variable "rds_db_name" {
  description = "RDS database name"
  default     = "saleor"
}

variable "rds_username" {
  description = "RDS database username"
  default     = "saleor"
}

variable "rds_password" {
  description = "RDS database password"
}

variable "rds_instance_class" {
  description = "RDS instance type"
  default     = "db.t2.micro"
}

# domain

variable "certificate_arn" {
  description = "AWS Certificate Manager ARN"
  default     = "arn:aws:acm:<Your ARN>"
}

variable "domain_name" {
  default = "ladniezrobione.pl"
}
