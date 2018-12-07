# Flogo Web UI on AWS Fargate with Terraform

## Prerequisites

* an AWS account
* an IAM user with following strategies:
  * AmazonEC2FullAccess
  * IAMFullAccess
  * ElasticLoadBalancingFullAccess
  * AmazonECS_FullAccess
* a couple of access key/secret key associated with the IAM user
* [Terraform](https://www.terraform.io/) (tested with v0.11.10)
* (optional), [jq](https://stedolan.github.io/jq/)

## Usage

1. clone this directory
```
git clone https://github.com/square-it/terraform-fargate-flogo-web-ui.git
cd terraform-fargate-flogo-web-ui
```

2. create a Terraform variables file with the AWS credentials
```
echo 'aws_access_key = "<YOUR_AWS_ACCESS_KEY>"' > terraform.tfvars
echo 'aws_secret_key = "<YOUR_AWS_SECRET_KEY>"' >> terraform.tfvars
```

3. launch Terraform
```
terraform init
terraform apply -auto-approve
```

> This will create several AWS resources and might **cost you money** (unless you have a free tier account).

4. enjoy
```
echo "Flogo Web UI is available at: http://$(terraform output -json | jq -r '.alb_hostname.value')"
```

## Teardown

Once you're done (and to stop billing of unused resources), destroy the ECS cluster:
```
terraform destroy -auto-approve
```
