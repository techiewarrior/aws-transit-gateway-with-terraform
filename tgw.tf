
resource "aws_ec2_transit_gateway" "tgw" {
  default_route_table_association =  "disable"
  description                     = "tgw setup with terraform"
  auto_accept_shared_attachments = var.auto_accept_shared_attachments
  default_route_table_propagation =  "disable"

  tags = {
    Name = "transit-gw"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw-rtable" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

}


//resource "aws_ec2_transit_gateway_route_table" "tgw-rtable2" {
//  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

//}//

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att" {
  //depends_on                    = [aws_ec2_transit_gateway_route_table.tgw-rtable]
  subnet_ids                    = aws_subnet.private_subnets[*].id
  transit_gateway_id             = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation  = false
  vpc_id                         = aws_vpc.tgw-vpc.id
}



resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att2" {
  //depends_on                    = [aws_ec2_transit_gateway_route_table.tgw-rtable]
  subnet_ids                    = aws_subnet.vpc2-private_subnets[*].id
  transit_gateway_id             = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation  = false
  vpc_id                         = aws_vpc.tgw-vpc2.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rta" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtable.id

  }


resource "aws_ec2_transit_gateway_route_table_association" "tgw-rta2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtable.id

}

resource "aws_ec2_transit_gateway_route" "tgw-rte" {
  destination_cidr_block         = var.exit_rte_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtable.id
}


resource "aws_ec2_transit_gateway_route" "tgw-rte3" {
  destination_cidr_block         = var.cidr_block_a
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtable.id
}

resource "aws_ec2_transit_gateway_route" "tgw-rte2" {
  destination_cidr_block         = var.cidr_block_a2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-att2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rtable.id
}
