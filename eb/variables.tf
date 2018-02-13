variable "app_name" {}
variable "app_name_sufix" {}
variable "description" {}
variable "solution_stack_name" {}

variable "environment_names" {
  type = "list"
}

variable "vpc_id" {}

variable "subnet_id" {
  type = "list"
}

variable "autoscaling_group_min" {}
variable "autoscaling_group_max" {}
variable "autoscaling_trigger_measure" {}
variable "autoscaling_trigger_average" {}
variable "autoscaling_trigger_unit" {}
variable "autoscaling_trigger_lothreshold" {}
variable "autoscaling_trigger_upthreshold" {}

variable "environment_variables" {
  type = "map"
}

variable "iam_policies" {
  type = "map"
}
