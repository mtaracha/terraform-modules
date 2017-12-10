/*
  General settings
*/
variable "service_name" {
  default     = "pathfinder"
  description = "Name of the service i.e. pathfinder"
}

variable "container_port" {
  default     = "5000"
  description = "Port exposed from the container image i.e. 5000"
}

variable "image_tag" {
  default = "master.9"
  description = "docker image tag i.e. master.9"
}

variable "alb_listener_rule_priority" {
  default     = "99" # This needs to be changed at module definition level!!!
  description = "The priority for the rule. A listener can't have multiple rules with the same priority"
}

variable "deregistration_delay" {
  default     = "30"
  description = "The amount time for ALB to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds"
}

/*
  Resource allocation
*/
variable "cpu" {
  default = "0"
  description = "CPU allocation for task definition"
}

variable "memory" {
  default = "128"
  description = "memory allocation for task definition"
}

variable "desired_count" {
  default = "1"
  description = "Desired count of service containers"
}


/*
  IAM settings
*/
variable "iam_role" {
  default = "arn:aws:iam::796467622059:role/ecsServiceRole"
  description = "IAM role for ECS Service"
}

/*
  DNS settings
*/
variable "environment" {
  default = "dev"
  description = "environment + color"
}

variable "color" {
  default = "blue"
  description = "Color/version of infrastructure"
}

variable "r53_zone" {
  default = "ZW6IDLJZXY2S9"
  description = "DNS zone in Route53"
}

/*
  Underlying infrastructure TF state file
*/

variable "tf_state_bucket" {
  default = "terraform-state-stepweb-dev"
  description = "tf state bucket"
}

variable "tf_state_key" {
  default = "dev_env_dev_pipeline.tfenv"
  description = "state file of main infrastructure"
}

/*
  ENV variables
  * module supports 3 env vars but can be extended*
*/
variable "env_var1_name" {
  default = "NODE_ENV"
  description = "ENV variable name"
}
variable "env_var1_value" {
  default = "production"
  description = "ENV variable value"
}

variable "env_var2_name" {
  default = "TEST"
  description = "ENV variable name"
}
variable "env_var2_value" {
  default = "test"
  description = "ENV variable value"
}

variable "env_var3_name" {
  default = "NODE_TEST"
  description = "ENV variable name"
}
variable "env_var3_value" {
  default = "test"
  description = "ENV variable value"
}
