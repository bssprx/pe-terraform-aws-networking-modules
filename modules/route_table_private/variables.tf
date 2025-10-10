variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids_by_az" {
  description = "Map of private subnet IDs keyed by AZ"
  type        = map(string)
}

variable "nat_gateway_ids_by_az" {
  description = "Map of NAT Gateway IDs keyed by AZ"
  type        = map(string)
}

variable "name_prefix" {
  description = "Prefix to use for naming"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the route tables"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "The 'tags' variable must include both 'Environment' and 'Project'."
  }
}