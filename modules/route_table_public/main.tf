variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used to construct resource names"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
}

variable "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  type        = string
}

variable "public_subnet_ids_by_az" {
  description = "Map of availability zones to public subnet IDs"
  type        = map(string)
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-public-rt"
  })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route_table_association" "public" {
  count          = length(keys(var.public_subnet_ids_by_az))
  subnet_id      = values(var.public_subnet_ids_by_az)[count.index]
  route_table_id = aws_route_table.public.id
}

output "id" {
  value = aws_route_table.public.id
}