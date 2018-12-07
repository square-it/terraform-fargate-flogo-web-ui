variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-2"
}

variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "flogo/flogo-docker:v0.5.7"
}

variable "app_command" {
  description = "Command to execute when launching Docker container"
  default     = "eula-accept"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3303
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}
