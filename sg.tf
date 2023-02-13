#############################################################
# Data sources to get VPC and default security group details
#############################################################
data "aws_vpc" "default" {
  default = true
}

module "sg_gcsv5" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "gcsv5"
  description = "Security group for logging into servers using ssh"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["https-443-tcp", "ssh-tcp"]
  egress_rules = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 50000
      to_port     = 51000
      protocol    = 6
      description = "Globus Connect Server v5.4 Service Ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
