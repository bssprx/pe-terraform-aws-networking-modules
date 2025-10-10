resource "aws_route_table" "private" {
  for_each = var.private_subnet_ids_by_az

  vpc_id = var.vpc_id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
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

  depends_on = [aws_route_table.private]
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnet_ids_by_az

  subnet_id      = each.value
  route_table_id = aws_route_table.private[each.key].id
}
