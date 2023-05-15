# cloud watch dog role for cleanup process
resource "aws_iam_role" "watch_dog_iam" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.watch_dog_assume_role_policy.json
  description        = "Logging access to cloud watch dog"
  tags               = var.tags
}

# Allow cross account assume role policy
data "aws_iam_policy_document" "watch_dog_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals { 
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_id}:role/tlz_watchdog"
        ] 
    }
  }
}

# logging policy
data "aws_iam_policy_document" "watch_dog_custom_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
        "logs:DescribeLogGroups",
        "logs:DeleteLogGroup"
    ]
  }

  statement {
    effect    = "Allow"
    resources = [aws_iam_role.watch_dog_iam.arn]

    actions = [
        "iam:PassRole"
    ]
  }
}

resource "aws_iam_policy" "watch_dog_custom_policy" {
  name        = "tlz_cloud_watch_dog"
  description = "This grants access to cloudwatch and pass role"
  policy      = data.aws_iam_policy_document.watch_dog_custom_policy.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "watch_dog_custom_policy" {
  role       = aws_iam_role.watch_dog_iam.name
  policy_arn = aws_iam_policy.watch_dog_custom_policy.arn
}
