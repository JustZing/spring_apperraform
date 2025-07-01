output "security_group" {
  value = module.security_group
}

output "vpc" {
  value = module.vpc
}

output "rds" {
  value     = module.rds
  sensitive = true
}

