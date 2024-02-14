resource "aws_iam_role" "handler_lambda_exec" {
  name = "handler-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_ecr_repository" "ecr_repo" {
  name                 = "printip-lambda-image"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = false
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
  tags = {
    Name  = "worker-repository"
    Group = "test"
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_repository_policy" "demo-repo-policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "Set the permission for ECR",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}

resource "null_resource" "update_docker_image" {
  provisioner "local-exec" {
    working_dir = "dockerimage"
    command     = "chmod +x update-image.sh && sh -x update-image.sh"
  }

  depends_on = [aws_ecr_repository.ecr_repo, aws_ecr_lifecycle_policy.ecr_policy, aws_ecr_repository_policy.demo-repo-policy]
}


resource "aws_iam_role_policy_attachment" "handler_lambda_policy" {
  role       = aws_iam_role.handler_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_ecr_repository" "printip_ecr_repo" {
  name = "printip-lambda-image"
}

resource "aws_lambda_function" "printIP" {
  function_name = "printIP"
  timeout       = 5 # seconds
  image_uri     = "${data.aws_ecr_repository.printip_ecr_repo.repository_url}:latest"
  package_type  = "Image"
  role = aws_iam_role.handler_lambda_exec.arn
}


resource "aws_cloudwatch_log_group" "handler_lambda" {
  name = "/aws/lambda/${aws_lambda_function.printIP.function_name}"
}

