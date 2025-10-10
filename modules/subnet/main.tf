variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
}

variable "cidrs" {
  description = "List of CIDR blocks for the subnets"
  type = object({
    public    = optional(list(string), [])
    private   = optional(list(string), [])
    endpoints = optional(list(string), [])
  })

  validation {
    condition = alltrue([
      length(var.cidrs.public) == 0 || length(var.cidrs.public) == length(var.availability_zones),
      length(var.cidrs.private) == 0 || length(var.cidrs.private) == length(var.availability_zones),
      length(var.cidrs.endpoints) == 0 || length(var.cidrs.endpoints) == length(var.availability_zones)
    ])
    error_message = "Each CIDR list must be empty or match the length of availability_zones."
  }
}

variable "map_public_ip_on_launch" {
  description = "Whether to enable auto-assign public IP on launch for public subnets"
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "Prefix for subnet names"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain logs (if applicable)"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Map of tags to assign to the subnets. Must include 'Environment' and 'Project'."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "Tags must include 'Environment' and 'Project'."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to create the subnets in"
  type        = string
}

resource "aws_subnet" "this" {
  for_each = {
    for pair in flatten([
      for subnet_type, cidr_list in var.cidrs :
      [
        for idx, cidr in cidr_list : {
          key               = "${subnet_type}-${idx}"
          cidr_block        = cidr
          availability_zone = var.availability_zones[idx]
          type              = subnet_type
          index             = idx
        }
      ]
    ]) : pair.key => pair
  }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.type == "public" ? var.map_public_ip_on_launch : false

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${each.value.type}-${each.value.availability_zone}"
  })
}

output "availability_zones" {
  description = "Availability zones used for the subnets"
  value       = var.availability_zones
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    for key, subnet in aws_subnet.this :
    subnet.id if startswith(key, "private-")
  ]
}

output "private_subnet_ids_by_az" {
  description = "Map of private subnet IDs by AZ"
  value = {
    for key, subnet in aws_subnet.this :
    subnet.availability_zone => subnet.id
    if startswith(key, "private-")
  }
}

output "endpoint_subnet_ids" {
  description = "List of endpoint subnet IDs"
  value = [
    for key, subnet in aws_subnet.this :
    subnet.id if startswith(key, "endpoints-")
  ]
}

output "endpoint_subnet_ids_by_az" {
  description = "Map of endpoint subnet IDs by AZ"
  value = {
    for key, subnet in aws_subnet.this :
    subnet.availability_zone => subnet.id
    if startswith(key, "endpoints-")
  }
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    for key, subnet in aws_subnet.this :
    subnet.id if startswith(key, "public-")
  ]
}

output "public_subnet_ids_by_az" {
  description = "Map of public subnet IDs by AZ"
  value = {
    for key, subnet in aws_subnet.this :
    subnet.availability_zone => subnet.id
    if startswith(key, "public-")
  }
}

output "subnet_ids" {
  description = "List of subnet IDs created"
  value       = [for s in aws_subnet.this : s.id]
}

output "vpc_id" {
  description = "The VPC ID these subnets belong to"
  value       = var.vpc_id
}
