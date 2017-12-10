output "repository_url" {
  value = "${aws_ecr_repository.repository.url}"
}

output "service_name" {
  value = "${var.service_name}"
}

output "color" {
  value = "${var.color}"
}

output "alb_dns_name" {
  value = "${data.terraform_remote_state.ecs.alb_dns_name}"
}
