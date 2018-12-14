variable "namespace" {}
variable "stage" {}
variable "cidr_block" {}
variable "availability_zones" {
  type = "list"
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.3.5"
  namespace  = "${var.namespace}"
  name       = "vpc"
  stage      = "${var.stage}"
  cidr_block = "${var.cidr_block}"
}

locals {
  public_cidr_block  = "${cidrsubnet(module.vpc.vpc_cidr_block, 1, 0)}"
  private_cidr_block = "${cidrsubnet(module.vpc.vpc_cidr_block, 1, 1)}"
}

module "public_subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=tags/0.2.2"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "subnet"
  availability_zones  = "${var.availability_zones}"
  vpc_id              = "${module.vpc.vpc_id}"
  cidr_block          = "${local.public_cidr_block}"
  type                = "public"
  igw_id              = "${module.vpc.igw_id}"
  nat_gateway_enabled = "true"
}

module "private_subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=tags/0.2.2"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "subnet"
  availability_zones  = "${var.availability_zones}"
#  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id              = "${module.vpc.vpc_id}"
  cidr_block          = "${local.private_cidr_block}"
  type                = "private"

  # Map of AZ names to NAT Gateway IDs that was created in "public_subnets" module
  az_ngw_ids          = "${module.public_subnets.az_ngw_ids}"

  az_ngw_count = 2
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnet_ids" {
  value = "${module.private_subnets.az_subnet_ids}"
}

