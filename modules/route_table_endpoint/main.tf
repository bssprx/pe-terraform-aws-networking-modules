variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "endpoint_subnet_ids_by_az" {
  description = "Map of endpoint-only subnet IDs keyed by AZ"
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

resource "aws_route_table" "private" {
  for_each = var.endpoint_subnet_ids_by_az

  vpc_id = var.vpc_id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-endpoint-rt-${each.key}"
    }
  )
}

resource "aws_route_table_association" "endpoint" {
  for_each = var.endpoint_subnet_ids_by_az

  subnet_id      = each.value
  route_table_id = aws_route_table.endpoint[each.key].id
}

output "endpoint_route_table_ids_by_az" {
  description = "Map of endpoint-only route table IDs keyed by AZ"
  value = {
    for az, rt in aws_route_table.endpoint : az => rt.id
  }
}