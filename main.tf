# Specify the provider and access details

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  token      = "${var.aws_security_token}"
  region     = "${var.aws_region}"
}

variable "namespace" {
  default = "flogo-demo"
}

variable "stage" {
  default = "dev"
}

module "network" {
  source = "./common/network"

  namespace          = "${var.namespace}"
  stage              = "${var.stage}"

  cidr_block         = "172.17.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b"]
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name   = "${var.namespace}-${var.stage}"
}

module "flogo-web-ui" {
  source = "./apps/flogo-web-ui"

  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  vpc_id             = "${module.network.vpc_id}"
  ecs_cluster_arn    = "${module.ecs.this_ecs_cluster_id}"
  private_subnet_ids = "${values(module.network.private_subnet_ids)}"
}

/*
resource "aws_ecs_service" "main" {
  name            = "tf-ecs-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.private.*.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "app"
    container_port   = "${var.app_port}"
  }

  depends_on = [
    "aws_alb_listener.front_end",
  ]
}
*/
