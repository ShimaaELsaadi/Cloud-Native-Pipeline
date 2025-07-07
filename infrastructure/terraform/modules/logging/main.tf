resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "poc-${var.environment}-vpc-flow-logs"
  retention_in_days = var.log_retention_days
    tags = {
    Name = "poc-${var.environment}-vpc-flow-logs"
    Environment = var.environment
    }
}
resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.vpc_flow_log_role.arn
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id

  tags = {
    Name        = "poc-${var.environment}-vpc-flow-logs"
    Environment = var.environment
  }
}
resource "aws_s3_bucket" "central_logs" {
  count = var.environment == "prod" ? 1 : 0
  bucket = "poc-${var.environment}-central-logs"
  tags = {
    Name        = "poc-${var.environment}-central-logs"
    Environment = var.environment
  }
}
resource "aws_flow_log" "s3" {
  count                = var.environment == "prod" ? 1 : 0  
  log_destination      = aws_s3_bucket.central_logs[0].arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id

  tags = {
    Name        = "poc-${var.environment}-s3-flow-logs"
    Environment = var.environment
  }
}



