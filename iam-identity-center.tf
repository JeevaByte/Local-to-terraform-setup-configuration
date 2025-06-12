resource "aws_identitystore_group" "admin_group" {
  display_name      = "AdminGroup"
  description       = "Administrator group for CSI project"
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}

resource "aws_identitystore_group" "developer_group" {
  display_name      = "DeveloperGroup"
  description       = "Developer group for CSI project"
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
}

data "aws_ssoadmin_instances" "main" {}

resource "aws_ssoadmin_permission_set" "admin" {
  name             = "AdminPermissionSet"
  description      = "Permission set for administrators"
  instance_arn     = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  session_duration = "PT8H"
}

resource "aws_ssoadmin_permission_set" "developer" {
  name             = "DeveloperPermissionSet"
  description      = "Permission set for developers"
  instance_arn     = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "admin_policy" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "developer_policy" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_ssoadmin_account_assignment" "admin_assignment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.admin.arn
  
  principal_id   = aws_identitystore_group.admin_group.group_id
  principal_type = "GROUP"
  
  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "developer_assignment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn
  
  principal_id   = aws_identitystore_group.developer_group.group_id
  principal_type = "GROUP"
  
  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}