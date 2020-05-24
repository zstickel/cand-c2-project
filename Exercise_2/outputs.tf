# TODO: Define the output variable for the lambda function.

output "lambda_output" {
    description = "Result of Lambda execution"
    value = "${data.aws_lambda_invocation.example.result}"
}
