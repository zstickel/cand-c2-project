provider "aws" {
    region =  "${var.aws_region_name}"
    access_key = "AKIATDR3YNFCRNBEXGE6"
    secret_key = "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"
}

data "archive_file" "greet_lambda_zip" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = "greet_lambda.zip"
}
data "aws_lambda_invocation" "example" {
  function_name = "${aws_lambda_function.greet_lambda.function_name}"
  input = <<JSON
{
  "greeting": "Hello Udacity from payload"
}
JSON
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

resource "aws_lambda_function" "greet_lambda" {
 
  filename      = "greet_lambda.zip"
  function_name = "${var.lambda_function_name}"
  role          =  "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "greet_lambda.lambda_handler"
  runtime = "python3.8"
  depends_on = ["aws_iam_role_policy_attachment.lambda_logs", "aws_cloudwatch_log_group.example"]
  environment{
        variables = {
            greeting = "Hello Udacity"
        }
  }

}