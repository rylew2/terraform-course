// to setup autoscaling we need to main things:
// 1 => launch config
// 2 => autoscaling group



//launch configuration - specifies properties of the instance to be launched (AMI ID, sec group, keypair)
resource "aws_launch_configuration" "example-launchconfig" {
  name_prefix     = "example-launchconfig"
  image_id        = var.AMIS[var.AWS_REGION]  // we launch the same ami image id for all instances that get spun up
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mykeypair.key_name
  security_groups = [aws_security_group.allow-ssh.id]
}


// autoscaling group - specifies the
resource "aws_autoscaling_group" "example-autoscaling" {
  name                      = "example-autoscaling"

  // specify multiple for HA (2 or even 3 subnets)
  vpc_zone_identifier       = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_configuration      = aws_launch_configuration.example-launchconfig.name
  min_size                  = 1 // starts with 1 - then autoscaling event happens then it will go up to max size
  max_size                  = 2
  health_check_grace_period = 300

  // if you use load balancer , load balancer can do health check
  // in this case we don't have a load balancer so we just listen to EC2 and if there's an
  // issue with hw then instance will be removed from autoscaling group
  health_check_type         = "EC2"

  force_delete              = true // instance kicked out of asg are automatically deleted

  tag {  // everytime we have an instance launched, make sure its named
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true  
  }
}
