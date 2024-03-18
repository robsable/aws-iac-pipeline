### Variables ###
variable "aws_region" { 
  default = "us-east-1" 
  type = string
}

variable "app_name" { 
  default = "myapp"
  type = string
}

variable "app_env" { 
  default = "dev"
  type = string
}

variable "s3_backend_bucket" { 
  default = "tfstate-bucket-rs"
  type = string
}