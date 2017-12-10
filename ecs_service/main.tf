/*
  Create repository for service
*/
resource "aws_ecr_repository" "repository" {
  name = "${var.service_name}"
}
/*
  Get AWS account ID
*/
data "aws_caller_identity" "current" {}
/*
  Create CloudWatch log group for service
*/
resource "aws_cloudwatch_log_group" "log" {
  name = "${var.service_name}"

  tags {
    Environment = "${var.environment}"
    Role = "${var.service_name}"
    Creator = "terraform"
  }
}
/*
  Task definition setup
*/
resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.service_name}"
  volume {
    name = "stepweb_configs"
    host_path = "/etc/stepweb/${var.service_name}"
  }
  volume {
    name = "stepweb_logs"
    host_path = "/var/log/trufa/${var.service_name}"
  }
  container_definitions = <<DEFINITIONS
[
  {
    "cpu": ${var.cpu},
    "essential": true,
    "image": "registry.trufa.me/trufa/${var.service_name}:${var.image_tag}",
    "memory": ${var.memory},
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.service_name}",
            "awslogs-region": "eu-west-1",
            "awslogs-stream-prefix": "${var.service_name}"
        }
    },
    "name": "${var.service_name}",
    "environment": [
      {
        "name": "${var.env_var1_name}",
        "value": "${var.env_var1_value}"
      },
      {
        "name": "${var.env_var2_name}",
        "value": "${var.env_var2_value}"
      },
      {
        "name": "${var.env_var3_name}",
        "value": "${var.env_var3_value}"
      }
    ],
    "mountPoints": [
      {
        "containerPath": "/etc/stepweb/${var.service_name}",
        "sourceVolume": "stepweb_configs"
      },
      {
        "containerPath": "/var/log/trufa/${var.service_name}",
        "sourceVolume": "stepweb_logs"
      }
    ],
    "portMappings": [
      {
        "containerPort": ${var.container_port}
      }
    ]
  }
]
DEFINITIONS
}
/*
  TG - for service
*/
/*
  ALB target group
*/
resource "aws_alb_target_group" "ecs_tg" {
  name     = "${var.service_name}"
  port     = "80" // port will be random choosen by ecs agent
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.ecs.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path = "/"
    matcher = "200-499"
  }
}
/*
  ECS Service setup
*/
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.service_name}"
  cluster         = "${data.terraform_remote_state.ecs.cluster_id}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = "${var.desired_count}"
  iam_role        = "${var.iam_role}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs_tg.arn}"
    container_name   = "${var.service_name}"
    container_port   = "${var.container_port}"
  }
}
/*
  ALB listener rules
*/
resource "aws_alb_listener_rule" "alb_routing" {
  listener_arn = "${data.terraform_remote_state.ecs.listener_arn}"
  priority     = "${var.alb_listener_rule_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.ecs_tg.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.environment}-${var.service_name}.trufa.me"]
  }
}

resource "aws_alb_listener_rule" "alb_routing_color" {
  listener_arn = "${data.terraform_remote_state.ecs.listener_arn}"
  priority     = "${var.alb_listener_rule_priority - 1}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.ecs_tg.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.environment}-${var.color}-${var.service_name}.trufa.me"]
  }
}

/*
  Pull state file of main INFRASTRUCTURE
*/
data "terraform_remote_state" "ecs" {
  backend = "s3"
  config {
    bucket = "${var.tf_state_bucket}"
    key    = "${var.tf_state_key}"
    region = "eu-west-1"
  }
}
