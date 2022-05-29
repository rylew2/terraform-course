resource "aws_security_group" "allow-ssh" {
  vpc_id      = aws_vpc.main.id
  name        = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
    from_port   = 0 // 0 port means all ports
    to_port     = 0
    protocol    = "-1" // -1 is all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22 // ssh protocol
    to_port     = 22
    protocol    = "tcp"         // ssh only needs tcp
    cidr_blocks = ["0.0.0.0/0"] //could possibly update this to only our address which is more restrictive
  }
  tags = {
    Name = "allow-ssh"
  }
}
