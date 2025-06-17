variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to associate with the Internet Gateway."
  validation {
    condition     = length(trim(var.vpc_id, " ")) > 0
    error_message = "The vpc_id variable must be a non-empty string."
  }
}

variable "name_prefix" {
  type        = string
  description = "Prefix to use for naming the Internet Gateway."
  validation {
    condition     = length(trim(var.name_prefix, " ")) > 0
    error_message = "The name_prefix variable must be a non-empty string."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Internet Gateway resource. Must include 'Environment' and 'Project'."
  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "The tags map must include keys 'Environment' and 'Project'."
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

output "id" {
  value       = aws_internet_gateway.this.id
  description = "The ID of the Internet Gateway."
}