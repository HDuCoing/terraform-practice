variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.nano"
}
variable "ami_filter" {
  description = "AMI filter for the application"

  type = object({
    name = string
    owners = string
  })
  default = {
    name = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
    owners = ["979382823631"] # Bitnami
  }
}
variable "environment" {
  description = "Environment name"
  type = object({
    name = string
    network_prefix = string
  })
  default = {
    name = "dev"
    network_prefix = "10.0"
  }
}
variable "min_size" {
  description = "Minimum size of the Auto Scaling group"
  type        = number
  default     = 1
}
variable "max_size" {
  description = "Maximum size of the Auto Scaling group"
  type        = number
  default     = 2
}
 