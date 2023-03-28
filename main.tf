# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}
provider "archive" {}

resource "aws_iam_role" "lambda" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda" {
  name = "lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        "Sid": "EventBridgePutEvents"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "events:PutEvents"
        ]
        Resource = "*"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = aws_iam_policy.lambda.arn
  role = aws_iam_role.lambda.name
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "PushtoEvents.py"
  output_path = "PushtoEvents.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "PushtoEvents"

  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"

  role    = "${aws_iam_role.lambda.arn}"
  handler = "PushtoEvents.lambda_handler"
  runtime = "python3.9"

}

data "archive_file" "zip1" {
  type        = "zip"
  source_file = "ReadEvents.py"
  output_path = "ReadEvents.zip"
}

  resource "aws_lambda_function" "lambda1" {
  function_name = "ReadEvents"

  filename         = "${data.archive_file.zip1.output_path}"
  source_code_hash = "${data.archive_file.zip1.output_base64sha256}"

  role    = "${aws_iam_role.lambda.arn}"
  handler = "ReadEvents.lambda_handler"
  runtime = "python3.9"

}
# Create Event Bus
resource "aws_cloudwatch_event_bus" "my_event_bus" {
  name = "my-event-bus1"
}

resource "aws_cloudwatch_event_rule" "my_event_rule" {
  name        = "my-event-rule1"
  description = "My custom event rule"
  event_bus_name = aws_cloudwatch_event_bus.my_event_bus.name
  event_pattern = <<PATTERN
{
  "detail": {
    "married": [
      "true"
    ]
  }
}

PATTERN
}

resource "aws_lambda_permission" "my_lambda_permission" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda1.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.my_event_rule.arn
}




resource "aws_cloudwatch_event_target" "my_lambda_target" {
  rule      = aws_cloudwatch_event_rule.my_event_rule.name
  event_bus_name = aws_cloudwatch_event_bus.my_event_bus.name
  arn       = aws_lambda_function.lambda1.arn
}


