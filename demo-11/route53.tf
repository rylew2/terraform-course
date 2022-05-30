
resource "aws_route53_zone" "newtech-academy" {
  name = "newtech.academy"
}

resource "aws_route53_record" "server1-record" {
  zone_id = aws_route53_zone.newtech-academy.zone_id
  name    = "server1.newtech.academy"
  type    = "A" // A => resolving hostname to ip address (server1.newtech.academy => 104.236.247.8)
  ttl     = "300"
  records = ["104.236.247.8"]
}

resource "aws_route53_record" "www-record" {
  zone_id = aws_route53_zone.newtech-academy.zone_id
  name    = "www.newtech.academy"
  type    = "A"
  ttl     = "300"
  records = ["104.236.247.8"]
}

resource "aws_route53_record" "mail1-record" {
  zone_id = aws_route53_zone.newtech-academy.zone_id
  name    = "newtech.academy"
  type    = "MX" // for email - can use  points to google.com records (in prioroti)
  ttl     = "300"
  records = [ //prioritized order
    // have to buy google apps if you want to bind these domain names to google
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 aspmx2.googlemail.com.",
    "10 aspmx3.googlemail.com.",
  ]
}


// display the name servers
// what name servers we have to use on domain name
output "ns-servers" {
  value = aws_route53_zone.newtech-academy.name_servers
}
// log into acct of domain name and enter these name servers
