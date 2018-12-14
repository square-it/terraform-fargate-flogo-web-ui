module "container_definition" {
  source          = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.6.0"
  container_name  = "flogo-web-ui-app"
  container_image = "flogo/flogo-docker:v0.5.7"

  command         = ["eula-accept"]

   port_mappings = [
    {
      containerPort = 3303
      hostPort      = 3303
      protocol      = "tcp"
    }
  ]
}
