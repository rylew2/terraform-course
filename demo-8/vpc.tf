# Internet VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" // 10.0.x.x

  // every instance will have default tenancy, multiple instances on one physical hardware
  // can change to have one instance per physical machine but its more expensive so most ppl don't use
  // As of 2017 people can use dedicate hardware for PHI workloads (instead of Dedicate Instance/Hosts)
  instance_tenancy = "default"

  enable_dns_support   = "true" // on instance gives internal hostname and domain name
  enable_dns_hostnames = "true"
  enable_classiclink   = "false" // if you want to link your vpc to ec2 classic (if not ec2 classic set false)
  tags = {
    Name = "main" // helpful
  }
}

# Subnets

/////////////////////////
//PUBLIC SUBNETS
///////////////////////////////
resource "aws_subnet" "main-public-1" {
  //
  vpc_id = aws_vpc.main.id

  // instances launced in this subnet will get an ip from this cidr block
  // plus a public ip to connect to internet
  cidr_block              = "10.0.1.0/24" // 10.0.1.x  (minus the aws reserved)

  // map_public_ip_on_launch set to true will make 
  map_public_ip_on_launch = "true"        //give every instance in this subnet a public ip on launch
  availability_zone       = "us-west-2a"

  tags = {
    Name = "main-public-1"
  }
}

resource "aws_subnet" "main-public-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "main-public-2"
  }
}

resource "aws_subnet" "main-public-3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2c"

  tags = {
    Name = "main-public-3"
  }
}


/////////////////////////
// PRIVATE SUBNETS
///////////////////////////////

resource "aws_subnet" "main-private-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"

  // when you launch instances in this subnet, you only get private ip
  map_public_ip_on_launch = "false" //no public on launch
  availability_zone       = "us-west-2a"

  tags = {
    Name = "main-private-1"
  }
}

resource "aws_subnet" "main-private-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "main-private-2"
  }
}

resource "aws_subnet" "main-private-3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2c"

  tags = {
    Name = "main-private-3"
  }
}

////////////////////
# Internet GW
/////////////////////
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

////////////////
# route tables
////////////////////////
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id


  // push a route that says all traffic that is not internal are routed over internet gateway
  // ie if you want to contact a website, website ip will be different than your vpc range,
  // so it will go over internet gateway

  // MUST ASSOCIATE WITH ALL 3 PUBLIC SUBNET
  route {
    cidr_block = "0.0.0.0/0" //refers to all ip addresses (except the ones in the vpc)
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "main-public-1"
  }
}

////////////////////////////
# route associations public
//////////////////////////////
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.main-public-2.id
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-3-a" {
  subnet_id      = aws_subnet.main-public-3.id
  route_table_id = aws_route_table.main-public.id
}
