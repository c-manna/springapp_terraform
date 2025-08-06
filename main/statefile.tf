terraform {
  backend "s3" {
    bucket  = "github-terraform-bucket-s3"
    key     = "infra.tfstate"
    region  = "ap-south-1"
    profile = "default"
    acl    = "private"
    use_lockfile   = true
    # dynamodb_table = "vegeta-terraform-remote-state-table"
  }
}
