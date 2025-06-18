// Combine standard and custom tags into a single map for consistent tag propagation
locals {
  name_prefix = var.name_prefix
  environment = var.environment
  project     = var.project

  tags = merge({
    Environment = local.environment
    Project     = local.project
  }, var.additional_tags)
}
