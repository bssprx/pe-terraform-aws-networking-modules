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

resource "aws_route_table" "private" {
  for_each = var.private_subnet_ids_by_az

  vpc_id = var.vpc_id

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-rt-${each.key}"
    }
  )
}

resource "aws_route" "nat_gateway" {
  for_each = var.nat_gateway_ids_by_az

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnet_ids_by_az

  subnet_id      = each.value
  route_table_id = aws_route_table.private[each.key].id
}

output "private_route_table_ids_by_az" {
  description = "Map of private route table IDs keyed by AZ"
  value = {
    for az, rt in aws_route_table.private : az => rt.id
  }
}