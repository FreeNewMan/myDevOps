

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_user_id" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  value = data.aws_region.current.name
}


output "instance_ip_addr" {
  value = aws_instance.web.private_ip
}

output "aws_subnet_id" {
  value = aws_instance.web.subnet_id
}

