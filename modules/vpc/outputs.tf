output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.infra.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "private_subnet_az1_id" {
  value = aws_subnet.private_subnet_az1.id
}

output "private_subnet_az2_id" {
  value = aws_subnet.private_subnet_az2.id
}

output "secure_subnet_az1_id" {
  value = aws_subnet.secure_subnet_az1.id
}

output "secure_subnet_az2_id" {
  value = aws_subnet.secure_subnet_az2.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway.id
} 

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_az1.id,
    aws_subnet.public_subnet_az2.id,
  ]
}

