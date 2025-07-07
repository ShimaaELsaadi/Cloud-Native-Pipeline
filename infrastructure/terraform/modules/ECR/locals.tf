locals {
  encryption_configuration = (
    var.encryption_type == "KMS"
    ? [
      {
        encryption_type = "KMS"
        kms_key = aws_kms_key.kms_key[0].arn
      }
    ]
    : [
      {
        encryption_type = var.encryption_type
        kms_key         = null
      }
    ]
  ) 

  image_scanning_configuration = length(var.image_scanning_configuration) > 0 ? var.image_scanning_configuration : [ { scan_on_push = true } ]
  timeouts = var.timeouts != null ? [var.timeouts] : []


}


