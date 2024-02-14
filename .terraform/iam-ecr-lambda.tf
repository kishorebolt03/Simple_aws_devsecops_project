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

data "aws_ecr_repository" "printip_ecr_repo" {
  name = "printip-lambda-image"
}

resource "aws_iam_role_policy_attachment" "handler_lambda_policy" {
  role       = aws_iam_role.handler_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "printIP" {
  function_name = "printIP"
  timeout       = 5 # seconds
  image_uri     = "${data.aws_ecr_repository.printip_ecr_repo.repository_url}:latest"
  package_type  = "Image"
  role = aws_iam_role.handler_lambda_exec.arn
  source_code_hash=trimprefix(data.aws_ecr_repository.printip_ecr_repo.id, "sha256:")
}


resource "aws_cloudwatch_log_group" "handler_lambda" {
  name = "/aws/lambda/${aws_lambda_function.printIP.function_name}"
}

