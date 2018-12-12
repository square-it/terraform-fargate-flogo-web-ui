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

# optionally, if using a security token
echo 'aws_security_token = "<YOUR_AWS_SECURITY_TOKEN>"' >> terraform.tfvars
```

3. optionally, set up a backend to synchronize Terraform state, for instance with an AWS S3 bucket:
```
export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY>
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_KEY>

cat << EOF > ./backend.tf
terraform {
  backend "s3" {
    bucket = "<NAME_OF_THE_S3_BUCKET>"
    key    = "path/to/state/terraform.tfstate"
    region = "eu-west-2" # the region of the bucket
  }
}
EOF
```

Read carefully the [instructions to set up an AWS S3 backend](https://www.terraform.io/docs/backends/types/s3.html).

4. launch Terraform
```
terraform init
terraform apply -auto-approve
```

> This will create several AWS resources and might **cost you money** (unless you have a free tier account).

5. enjoy
```
echo "Flogo Web UI is available at: http://$(terraform output -json | jq -r '.alb_hostname.value')"
```

## Teardown

Once you're done (and to stop billing of unused resources), destroy the ECS cluster:
```
terraform destroy -auto-approve
```
