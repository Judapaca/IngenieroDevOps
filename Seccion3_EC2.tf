##Bloques Data##
data "aws_vpc" "vpc_default" {
  default = true
}

data "aws_subnet" "zd_1s" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

##Logica##
resource "aws_instance" "seccion3" {
  ami                         = "ami-01816d07b1128cd2d"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.seccion3.id]
  subnet_id                   = data.aws_subnet.zd_1s.id

  tags = {
    Name = "seccion3"
  }
}

##Security-Group#
resource "aws_security_group" "seccion3" {
  name        = "sg_seccion3"
  description = "grupo de seguridad instancia"
  vpc_id      = data.aws_vpc.vpc_default.id
}
resource "aws_security_group_rule" "regla_uno" {

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  description       = "regla_entrada"
  security_group_id = aws_security_group.seccion3.id
  cidr_blocks       = ["192.168.1.0/24"]
}
resource "aws_security_group_rule" "regla_dos" {

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  description       = "regla_entrada"
  security_group_id = aws_security_group.seccion3.id
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "regla_tres" {

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "regla_entrada"
  security_group_id = aws_security_group.seccion3.id
  cidr_blocks       = ["0.0.0.0/0"]
}

##### Subnet privada #####
resource "aws_subnet" "subred_privada" {
  vpc_id            = data.aws_vpc.vpc_default.id
  cidr_block        = "172.31.250.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subred-privada"
  }
}

##### Ruta table #####
resource "aws_route_table" "mi_tabla_ruta_privada" {
  vpc_id = data.aws_vpc.vpc_default.id

  tags = {
    Name = "tabla-rutas-privada"
  }
}
resource "aws_route_table_association" "asociacion_privada" {
  subnet_id      = aws_subnet.subred_privada.id
  route_table_id = aws_route_table.mi_tabla_ruta_privada.id
}