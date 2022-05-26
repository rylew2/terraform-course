terraform {
  backend "s3" {
      bucket = "terraform-state-f29c6"
      key = "terraform/demo4"
  }
}
