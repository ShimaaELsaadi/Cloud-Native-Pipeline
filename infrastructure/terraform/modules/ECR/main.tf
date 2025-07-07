resource "aws_ecr_repository" "repo" {
  name                 = var.ecr_repository_name
  force_delete         = var.force_delete
  image_tag_mutability = var.image_tag_mutability

    dynamic "encryption_configuration" {
    for_each = local.encryption_configuration

    content {
        encryption_type = encryption_configuration.value.encryption_type
        kms_key         = lookup(encryption_configuration.value, "kms_key", null)
    }
    }
    dynamic "image_scanning_configuration" {
        for_each = local.image_scanning_configuration
        content {
            scan_on_push = true
        }
      
    }
    timeouts {
      delete = var.timeouts[0].delete
    }


  tags = merge(
    {
      Name = var.ecr_repository_name
      "ManagedBy" = "Terraform"
    },
    var.tags
  )
    lifecycle {
    ignore_changes = [
      image_tag_mutability,
      encryption_configuration,
      image_scanning_configuration,
      timeouts
    ]

    }
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "AllowAll",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
      }
    ]
  })


  depends_on = [
    aws_ecr_repository.repo,
  ]
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.repo.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 14 days"
        selection = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 14
        }
        action = {
          type = "expire"
        }
      }
        ]
  })

  depends_on = [
    aws_ecr_repository.repo,
  ]
}

resource "aws_kms_key" "kms_key" {
  count                   = (var.encryption_type == "KMS" && var.kms_key == null) ? 1 : 0
  description             = "KMS key for ECR repository ${var.ecr_repository_name} encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  multi_region            = false

  tags = merge(
    {
      Name      = "${var.ecr_repository_name}-kms-key"
      ManagedBy = "Terraform"
    },
    var.tags
  )

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM Root User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
           "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow ECR Service to use the key"
        Effect = "Allow"
        Principal = {
          Service = "ecr.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:Encrypt"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow Key Users"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}
