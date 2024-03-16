### Locals ###
locals {
  account_id  = data.aws_caller_identity.current.account_id
}

### Amazon S3 ###
resource "aws_s3_bucket" "bucket_1" {
  bucket = "${var.app_name}-${local.account_id}-${var.app_env}-tf"
}

### SQS ###
resource "aws_sqs_queue" "main_queue" {
  name = "${var.app_name}-${var.app_env}-queue-tf-main"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_queue_dl.arn
    maxReceiveCount     = 4
  })  
}

resource "aws_sqs_queue" "sqs_queue_dl" {
  name = "${var.app_name}-${var.app_env}-queue-tf-dl"
}

resource "aws_sqs_queue_redrive_allow_policy" "my_redrive_allow_policy" {
  queue_url = aws_sqs_queue.sqs_queue_dl.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.main_queue.arn]
  })
}
