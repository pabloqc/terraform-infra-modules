############################# Tags #############################

variable "owner" {}
variable "project" {}
variable "environment" {}
variable "description" {}

############################# ElasticBeanstalk #############################

variable "solution_stack_name" {}
variable "vpc_id" {}
variable "ec2_public" {}
variable "subnet_id" {
  type = "list"
}
variable "ec2_key_name" {}
variable "instance_type" {}
variable "elb_visibility" {}
variable "elb_type" {}

variable "listener_protocol" {
  default = "HTTP"
}

variable "autoscaling_group_min" {}
variable "autoscaling_group_max" {}
variable "autoscaling_trigger_measure" {}
variable "autoscaling_trigger_average" {}
variable "autoscaling_trigger_unit" {}
variable "autoscaling_trigger_lothreshold" {}
variable "autoscaling_trigger_upthreshold" {}

variable "environment_variables" {
  type = "list"
}

variable "iam_policies" {
  type = "map"
}
