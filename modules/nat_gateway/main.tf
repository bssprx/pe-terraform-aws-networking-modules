variable "subnet_id" {
  description = "The ID of the public subnet in which to place the NAT Gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the NAT Gateway and associated resources"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in ["Environment", "Project"] : contains(keys(var.tags), k)])
    error_message = "The 'tags' map must include both 'Environment' and 'Project' keys."
  }
}

variable "name_prefix" {
  description = "Prefix to use for naming the NAT Gateway"
  type        = string
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-gateway"
    }
  )

  depends_on = [aws_eip.nat]

  lifecycle {
    ignore_changes = [tags]
  }
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway resource created in this module. This value can be used to reference the NAT Gateway for routing or other module integrations."
  value       = aws_nat_gateway.this.id
}
