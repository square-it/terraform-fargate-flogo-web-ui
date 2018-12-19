variable "namespace" {}
variable "stage" {}

variable "ecs_cluster_arn" {}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = "list"
}

module "alb" {
  source             = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.2.6"

  namespace          = "${var.namespace}"
  stage              = "${var.stage}"

  name               = "instance1"

  vpc_id             = "${var.vpc_id}"
  ip_address_type    = "ipv4"

  subnet_ids         = "${var.private_subnet_ids}"

  access_logs_enabled = "true"
  access_logs_region  = "eu-west-2"
}

module "alb_service_task" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.6.2"
  namespace                 = "${var.namespace}"
  stage                     = "${var.stage}"

  name                      = "instance1-task"

  container_definition_json = "${module.container_definition.json}"
  container_name            = "flogo-web-ui-app"
  ecs_cluster_arn           = "${var.ecs_cluster_arn}"
  launch_type               = "FARGATE"

  vpc_id                    = "${var.vpc_id}"
  private_subnet_ids        = "${var.private_subnet_ids}"

  alb_target_group_arn      = "${module.alb.default_target_group_arn}"
  security_group_ids        = ["${module.alb.security_group_id}"]
}
