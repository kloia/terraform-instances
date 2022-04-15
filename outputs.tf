output "master-public-ips" {
  value = data.aws_instances.masters.public_ips
}

output "worker-public-ips" {
  value = data.aws_instances.workers.public_ips
}

output "private-lb-dns" {
  value       = data.aws_lb.lb-private.dns_name
}

output "public-lb-dns" {
  value       = data.aws_lb.lb-public.dns_name
}