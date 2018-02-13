resource "aws_elastic_beanstalk_application" "upday-app-tf" {
  name        = "${var.app_name}${var.app_name_sufix}"
  description = "${var.description}"
}

resource "aws_elastic_beanstalk_environment" "upday-env-tf" {
  count               = "${length(var.environment_names)}"
  name                = "${var.app_name}-${var.environment_names[count.index]}"
  application         = "${aws_elastic_beanstalk_application.upday-app-tf.name}"
  solution_stack_name = "${var.solution_stack_name}"

  ############################# Elasticbeanstalk Settings #############################
  #
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html


  ############################# Network Tier #############################

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "True"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", var.subnet_id)}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", var.subnet_id)}"
  }

  ############################# Loadbalancer #############################

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "${var.elb_visibility}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "${var.elb_type}"
  }

  ############################# Health Reporting #############################

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "HTTP:80/health"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  ############################# Launch Configuration #############################

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "kitchen"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.medium"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.eb_service_profile.arn}"
  }

  ############################# Autoscaling Group #############################

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "${var.autoscaling_group_min}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.autoscaling_group_max}"
  }

  ############################# Autoscaling Trigger #############################

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "${var.autoscaling_trigger_measure}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "${var.autoscaling_trigger_average}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "${var.autoscaling_trigger_unit}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "${var.autoscaling_trigger_lothreshold}"
  }
  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "${var.autoscaling_trigger_upthreshold}"
  }

  ############################# Update Policy #############################

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = "1"
  }

  ############################# Environment Variables #############################

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "foo_url"
    value     = "${lookup(var.environment_variables, "foo_url")}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "best_framework_in_the_world"
    value     = "${lookup(var.environment_variables, "best_framework_in_the_world")}"
  }
}
