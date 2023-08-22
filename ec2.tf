locals {
    multiple_instances = {
        one = {
            instance_type = var.instance_type
            ami = var.ami
            key_name = var.key_name
            monitoring = true
            vpc_security_group_ids = [module.sg_gcsv5.security_group_id]
        }
        two = {
            instance_type = var.instance_type
            ami = var.ami
            key_name = var.key_name
            monitoring = true
            vpc_security_group_ids = [module.sg_gcsv5.security_group_id]
        }
    }
}

module "ec2_gcsv5" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  
  for_each = local.multiple_instances
  
  name = "${var.instance_name}-${each.key}-${var.environment}"

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  key_name               = each.value.key_name
  monitoring             = each.value.monitoring
  vpc_security_group_ids = each.value.vpc_security_group_ids
}
