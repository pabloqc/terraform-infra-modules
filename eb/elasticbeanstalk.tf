resource "aws_elastic_beanstalk_application" "upday-app-tf" {
  name        = "${var.owner}-${var.project}"
  description = "${var.description}"
}

resource "aws_elastic_beanstalk_environment" "upday-env-tf" {
  name                = "${var.project}-${var.environment}"
  application         = "${aws_elastic_beanstalk_application.upday-app-tf.name}"
  solution_stack_name = "${var.solution_stack_name}"

  tags {
    Name        = "${var.owner}-${var.project}-${var.environment}"
    Owner       = "${var.owner}"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Terraform   = "True"
  }

  ############################# Elasticbeanstalk Settings #############################
  #
  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html

  ############################# Environment Variables #############################

  setting = ["${var.environment_variables}"]

  ############################# Network Tier #############################

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "${var.ec2_public}"
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
  setting {
    namespace = "aws:elb:listener:listener_port"
    name      = "ListenerProtocol"
    value     = "${var.listener_protocol}"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
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
    value     = "${var.ec2_key_name}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.eb_service_profile.arn}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = "gp2"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = "64"
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
}
