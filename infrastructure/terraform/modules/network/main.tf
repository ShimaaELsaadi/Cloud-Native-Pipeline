resource "aws_vpc" "this" {
  cidr_block = var.vpc_config.cidr_block
  tags = {
    Name = local.vpc_tags
  }
}

resource "aws_subnet" "this" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.available.names[index(keys(var.subnet_config), each.key) % length(data.aws_availability_zones.available.names)]
  cidr_block        = each.value.cidr_block
  map_public_ip_on_launch = each.value.public

  tags = {
    Name   = "poc-${var.environment}-${each.key}"
    Access = each.value.public ? "Public" : "Private"
  }
}
resource "aws_internet_gateway" "this" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "poc-${var.environment}-igw"
  }
}

resource "aws_route_table" "public_rtb" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
  tags = {
    Name = "poc-${var.environment}-public-rtb"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public_rtb[0].id
}