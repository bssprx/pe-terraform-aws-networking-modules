# PE Terraform AWS Networking Modules

Reusable, production-ready Terraform modules for common AWS networking building blocks. Each module is designed to be composable, opinionated about required tagging, and safe to reuse across environments.

## Module Catalog

| Module | Description |
|--------|-------------|
| [`vpc`](modules/vpc) | Creates an Amazon VPC with DNS options and a protected lifecycle. |
| [`subnet`](modules/subnet) | Provisions coordinated public, private, and endpoint subnets across AZs with CIDR/AZ validation. |
| [`route_table_public`](modules/route_table_public) | Publishes a public route table and associates public subnets. |
| [`route_table_private`](modules/route_table_private) | Creates per-AZ private route tables wired to NAT gateways. |
| [`internet_gateway`](modules/internet_gateway) | Manages an Internet Gateway attached to the VPC. |
| [`nat_gateway`](modules/nat_gateway) | Allocates Elastic IPs and deploys managed NAT gateways. |
| [`security_group`](modules/security_group) | Builds configurable security groups with dynamic ingress/egress blocks. |
| [`flow_log`](modules/flow_log) | Enables VPC, subnet, or ENI flow logs with optional CloudWatch log group creation. |
| [`cloudwatch_log_group`](modules/cloudwatch_log_group) | Creates CloudWatch log groups with tagging and retention policy. |
| [`cloudwatch_alarm`](modules/cloudwatch_alarm) | Defines reusable CloudWatch metric alarms. |
| [`cloudwatch_notifications`](modules/cloudwatch_notifications) | Provisions SNS topics and subscribers for alarm routing. |
| [`cloudwatch_monitoring_rule`](modules/cloudwatch_monitoring_rule) | Deploys EventBridge rules and optional alarms for monitoring. |
| [`transit_gateway_attachment`](modules/transit_gateway_attachment) | Handles TGW VPC attachments with DNS/IPv6 options. |
| [`iam_role`](modules/iam_role) & [`iam_policy`](modules/iam_policy) | Supplies IAM roles and inline policies for logging/automation use cases. |

## Getting Started

1. **Select modules** and reference the desired release tag (latest: `v0.4.0`).
2. **Provide required tags** – every module expects `Environment` and `Project` keys.
3. **Run Terraform tooling** (`terraform init`, `terraform plan`, etc.) once your configuration is assembled.

### Minimal VPC example

```hcl
module "network" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/vpc?ref=v0.4.0"

  name_prefix    = "example"
  vpc_cidr_block = "10.0.0.0/16"
  tags = {
    Environment = "dev"
    Project     = "example-network"
  }
}
```

## Examples

The [`examples/complete`](examples/complete) configuration demonstrates how the modules compose into a full VPC, subnet, NAT, and monitoring stack. Clone it to experiment locally:

```bash
git clone https://github.com/bssprx/pe-terraform-aws-networking-modules.git
cd pe-terraform-aws-networking-modules/examples/complete
terraform init -backend=false
terraform plan
```

## Versioning & Support

- Releases follow semantic versioning; tags (`vX.Y.Z`) are immutable and map directly to module sources.
- `main` reflects the latest development state. Pin modules to a release tag in production.
- See `CHANGELOG.md` for curated release notes.

## Tooling & Validation

- **Pre-commit hooks:** install with `pre-commit install` to run `terraform fmt` and `terraform-docs` automatically.
- **Documentation:** module READMEs are generated with `terraform-docs --config .terraform-docs.yml .` executed at the repository root.
- **Manual checks:** run `terraform init -backend=false && terraform validate` inside each module or example after updating provider versions.

## Terraform Compatibility

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |
<!-- END_TF_DOCS -->
