module "ec2_gcsv5" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.instance_name}"

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [module.sg_gcsv5.security_group_id]
}
