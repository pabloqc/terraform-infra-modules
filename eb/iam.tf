############################# IAM Settings #############################
#
# https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts-roles.html

############################# Generate JSON Policy #############################

data "aws_iam_policy_document" "ec2_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

############################# Create Role #############################

resource "aws_iam_role" "eb_role" {
  name = "${var.owner}-${var.project}-eb-role"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.ec2_instance_policy.json}"
}

output "aws_iam_eb_role_name" {
  value = "${aws_iam_role.eb_role.name}"
}

############################# Role Attachment #############################

resource "aws_iam_role_policy_attachment" "eb_attachment" {
  count      = "${length(var.iam_policies)}"
  role       = "${aws_iam_role.eb_role.name}"
  policy_arn = "${lookup(var.iam_policies, count.index)}"
}

############################# Instance Profile #############################

resource "aws_iam_instance_profile" "eb_service_profile" {
  name = "${var.owner}-${var.project}-instance-profile"
  path = "/"
  role = "${aws_iam_role.eb_role.name}"
}
