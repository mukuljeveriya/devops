resource "aws_iam_role" "iam_role" {
  name = "${var.name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com","eks.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_policy" "cluster_autoscalling" {
  name        = "${var.name}-cluster_autoscalling"
  path        = "/"
  description = "cluster_autoscalling"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "cluster_CloudWatchMetric" {
  name        = "${var.name}-CloudWatchMetric"
  path        = "/"
  description = "cluster-CloudWatch Metric permissions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter"
            ],
            "Resource": "arn:aws:ssm:::parameter/AmazonCloudWatch-*"
        }
    ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_EKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iam_role.name
}


resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_autoscalling" {
  policy_arn = aws_iam_policy.cluster_autoscalling.arn
  role       = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_Cloudwatchpermissions" {
  policy_arn = aws_iam_policy.cluster_CloudWatchMetric.arn
  role       = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_EKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_role.name
}
