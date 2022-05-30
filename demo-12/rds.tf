resource "aws_db_subnet_group" "mariadb-subnet" {
  name        = "mariadb-subnet"
  description = "RDS subnet group"

  // when we launch we can choose if we prefer one
  subnet_ids  = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]
}

resource "aws_db_parameter_group" "mariadb-parameters" {
  name        = "mariadb-parameters"
  family      = "mariadb10.6"
  description = "MariaDB parameter group"


  // go into config file of the instance itself (no shell access to instance so this is onyl way to make changes to settings of db)
  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "mariadb" {

  // rec to use at least 100GB
  allocated_storage       = 100 # 100 GB of storage, gives us more IOPS than a lower number
  engine                  = "mariadb"
  engine_version          = "10.6.7"
  instance_class          = "db.t2.micro" # use micro if you want to use the free tier (2GB mem small, 1Gb for micro)
  identifier              = "mariadb"
#   name                    = "mariadb"
  db_name                 = "mariadb"
  username                = "root"           # username
  password                = var.RDS_PASSWORD # password
  db_subnet_group_name    = aws_db_subnet_group.mariadb-subnet.name
  parameter_group_name    = aws_db_parameter_group.mariadb-parameters.name //param group above

  //if master fails, slave takes over
  multi_az                = "false" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.allow-mariadb.id] //in securitygroup.tf (allow ssh and all egress)
  storage_type            = "gp2"
  backup_retention_period = 30  # how long you’re going to keep your backups (# days)
  availability_zone       = aws_subnet.main-private-1.availability_zone # preferred AZ
  skip_final_snapshot     = true     # skip final snapshot when doing terraform destroy
  tags = {
    Name = "mariadb-instance"
  }
}
