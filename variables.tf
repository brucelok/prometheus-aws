variable "aws_region" {
  description = "default region"
  default     = "ap-southeast-2"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair"
  default     = "mykey"
}

variable "subnet_id" {
  description = "Default"
  default    = "subnet-id"
}