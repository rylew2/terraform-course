# scale up alarm

// link to asg
resource "aws_autoscaling_policy" "example-cpu-policy" {
  name                   = "example-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.example-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"  // scales +1  (can also do -1)
  cooldown               = "300" //cooldown where no autoscaling can happen
  policy_type            = "SimpleScaling"  //simple is just +1
}


// cw alarm - which will trigger autoscaling policy
// if avg of cpu utilization is greater than 30% for a period of 120 seconds,
// if true then alarm will go off
resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm" {
  alarm_name          = "example-cpu-alarm"
  alarm_description   = "example-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2" // take avg of 2 periods and see if its over 30%
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"


    //the asg
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.example-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.example-cpu-policy.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "example-cpu-policy-scaledown" {
  name                   = "example-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.example-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "example-cpu-alarm-scaledown" {
  alarm_name          = "example-cpu-alarm-scaledown"
  alarm_description   = "example-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.example-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.example-cpu-policy-scaledown.arn]
}
