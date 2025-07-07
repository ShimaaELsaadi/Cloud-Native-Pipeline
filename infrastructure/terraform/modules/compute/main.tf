resource "aws_security_group" "this" {
  name        = local.security_group_name
  description = "Allow need ports"
  vpc_id      = var.vpc_id
  tags = {
    Name = local.security_group_name
  }
}
resource "aws_security_group_rule" "ingress" {
  for_each          = var.sg_config.ingress
  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = each.value.cidrs
  description       = each.key
}
resource "aws_security_group_rule" "egress" {
  for_each          = var.sg_config.egress
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  cidr_blocks       = each.value.cidrs
  description       = each.key
}

resource "aws_instance" "instance" {
  for_each = var.instances

  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = each.value.key_pair_name
  associate_public_ip_address = true

  tags = {
    Name = "poc-${var.environment}-${each.key}"
    Role = each.value.Role
  }
}



