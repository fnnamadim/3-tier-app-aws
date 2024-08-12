# Outputs to display useful information
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "web_instance_ids" {
  value = module.web.web_instance_ids
}

output "app_instance_ids" {
  value = module.app.app_instance_ids
}

output "db_instance_endpoint" {
  value = module.db.db_instance_endpoint
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
