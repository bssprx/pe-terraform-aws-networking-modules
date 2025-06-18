# subnet

This module provisions public and private subnets within a VPC based on a list of CIDRs and availability zones.

## Usage

```hcl
module "subnet" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/subnet"

  name_prefix              = "example"
  vpc_id                  = module.vpc.vpc_id
  availability_zones      = ["us-east-1a", "us-east-1b"]
  cidrs = {
    public  = ["10.0.1.0/24", "10.0.2.0/24"]
    private = ["10.0.11.0/24", "10.0.12.0/24"]
  }
  map_public_ip_on_launch = true
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones for the subnets | `list(string)` | n/a | yes |
| <a name="input_cidrs"></a> [cidrs](#input\_cidrs) | List of CIDR blocks for the subnets | <pre>object({<br/>    public  = list(string)<br/>    private = list(string)<br/>  })</pre> | n/a | yes |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | Whether to enable auto-assign public IP on launch | `bool` | `false` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for subnet names | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Number of days to retain logs (if applicable) | `number` | `90` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the subnets. Must include 'Environment' and 'Project'. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to create the subnets in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | Availability zones used for the subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of private subnet IDs |
| <a name="output_private_subnet_ids_by_az"></a> [private\_subnet\_ids\_by\_az](#output\_private\_subnet\_ids\_by\_az) | Map of private subnet IDs by AZ |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of public subnet IDs |
| <a name="output_public_subnet_ids_by_az"></a> [public\_subnet\_ids\_by\_az](#output\_public\_subnet\_ids\_by\_az) | Map of public subnet IDs by AZ |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of subnet IDs created |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID these subnets belong to |
<!-- END_TF_DOCS -->