# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------

resource "aws_ecr_repository" "ecr_repo" {
  name = var.name_prefix

  image_tag_mutability = var.image_tag_mutability ? "MUTABLE" : "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = var.enable_scan_on_push
  }

  tags = var.tags
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr_repo.id
  policy     = data.aws_iam_policy_document.ecr_policy_doc.json
}

data "aws_iam_policy_document" "ecr_policy_doc" {
  source_policy_documents = var.extra_ecr_policies

  statement {
    sid = "AllowTrustedAccounts"

    principals {
      type = "AWS"

      identifiers = formatlist("arn:aws:iam::%s:root", var.trusted_accounts)
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListTagsForResource",
    ]
  }
}

data "aws_ecr_lifecycle_policy_document" "lifecycle_policy" {
  rule {
    priority    = 1
    description = "Clean untagged images"

    selection {
      tag_status   = "untagged"
      count_type   = "imageCountMoreThan"
      count_number = var.max_untagged_images_retained
    }
  }

  dynamic "rule" {
    for_each = var.protected_image_tag_prefixes
    content {
      priority    = index(var.protected_image_tag_prefixes, rule.value) + 2 # TF lists are 0 indexed, and we want the first in the list to be at priority 2
      description = "Protect the ${rule.value} tag prefix"

      selection {
        tag_status      = "tagged"
        tag_prefix_list = [rule.value]
        count_type      = "imageCountMoreThan"
        count_number    = var.max_protected_images_retained
      }
    }
  }

  rule {
    priority    = length(var.protected_image_tag_prefixes) + 2
    description = "Keep last N images"

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = var.max_images_retained
    }
  }
}

resource "aws_ecr_lifecycle_policy" "keep_last_N" {
  repository = aws_ecr_repository.ecr_repo.id
  policy     = data.aws_ecr_lifecycle_policy_document.lifecycle_policy.json
}
