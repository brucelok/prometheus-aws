variable "region" {
  description = "default region"
  default     = "ap-southeast-2"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.small"
}

variable "key_name" {
  description = "Key pair"
  default     = "myMacbook"
}

variable "subnet_id" {
  description = "Default"
  default    = "subnet-0f72be4624adad8ff"
}