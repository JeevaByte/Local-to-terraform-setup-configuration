Feature: Security Best Practices
  In order to have secure infrastructure
  As engineers
  We'll implement security best practices

  Scenario: Ensure all S3 buckets have encryption enabled
    Given I have aws_s3_bucket defined
    Then it must contain server_side_encryption_configuration

  Scenario: Ensure all security groups restrict access
    Given I have aws_security_group defined
    When it contains ingress
    Then it must contain cidr_blocks
    And its cidr_blocks must not contain "0.0.0.0/0" with ports 22,3389

  Scenario: Ensure EKS cluster has logging enabled
    Given I have aws_eks_cluster defined
    Then it must contain enabled_cluster_log_types
    And its enabled_cluster_log_types must contain "api"
    And its enabled_cluster_log_types must contain "audit"