output "private_route_table_ids_by_az" {
  description = "Map of private route table IDs keyed by AZ"
  value = {
    for az, rt in aws_route_table.private : az => rt.id
  }
}