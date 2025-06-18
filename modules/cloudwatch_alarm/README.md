# cloudwatch_alarm

Creates a CloudWatch alarm for a specified metric with configurable threshold, evaluation period, and actions.

## Example Usage

```hcl
module "cloudwatch_alarm" {
  source = "git::https://github.com/bssprx/pe-terraform-aws-networking-modules.git//modules/cloudwatch_alarm"

  alarm_name           = "my-alarm"
  comparison_operator  = "GreaterThanThreshold"
  evaluation_periods   = 2
  metric_name          = "CPUUtilization"
  namespace            = "AWS/EC2"
  period               = 300
  threshold            = 80
  alarm_actions        = ["arn:aws:sns:us-east-1:123456789012:example"]
  tags                 = {
    Environment = "dev"
    Project     = "networking"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
