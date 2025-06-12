resource "aws_backup_vault" "eks_backup" {
  name = "eks-backup-vault"
}

resource "aws_backup_plan" "eks_backup" {
  name = "eks-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.eks_backup.name
    schedule          = "cron(0 5 * * ? *)"
    
    lifecycle {
      delete_after = 30
    }
  }

  rule {
    rule_name         = "weekly-backup"
    target_vault_name = aws_backup_vault.eks_backup.name
    schedule          = "cron(0 5 ? * SAT *)"
    
    lifecycle {
      delete_after = 90
    }
  }
}

resource "aws_backup_selection" "eks_backup" {
  name         = "eks-backup-selection"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.eks_backup.id

  resources = [
    module.eks.cluster_arn
  ]
}

resource "aws_iam_role" "backup_role" {
  name = "backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}