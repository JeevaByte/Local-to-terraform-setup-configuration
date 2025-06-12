# Disaster Recovery Plan

This document outlines the disaster recovery procedures for the CSI infrastructure.

## Backup Strategy

### EKS Cluster
- Daily backups via AWS Backup
- Weekly full backups retained for 90 days
- Daily incremental backups retained for 30 days

### State Management
- S3 bucket versioning enabled
- Cross-region replication to US-West-2
- Point-in-time recovery enabled

### Database
- Automated snapshots every 6 hours
- Transaction logs backed up continuously
- Cross-region replication for critical data

## Recovery Procedures

### Complete Infrastructure Failure

1. Ensure AWS credentials are configured
2. Restore Terraform state from backup:
   ```
   aws s3 cp s3://csi-terraform-state-replica/terraform.tfstate .
   ```
3. Initialize Terraform with the restored state:
   ```
   terraform init -backend-config="bucket=csi-terraform-state-replica"
   ```
4. Apply the Terraform configuration:
   ```
   terraform apply
   ```

### EKS Cluster Recovery

1. Identify the latest backup in AWS Backup vault
2. Initiate restore operation:
   ```
   aws backup start-restore-job \
     --recovery-point-arn <BACKUP_ARN> \
     --resource-type EKS \
     --iam-role-arn <BACKUP_ROLE_ARN>
   ```
3. Monitor restore progress:
   ```
   aws backup describe-restore-job --restore-job-id <RESTORE_JOB_ID>
   ```
4. Update kubeconfig to point to the restored cluster:
   ```
   aws eks update-kubeconfig --name csi-eks-cluster --region us-east-1
   ```
5. Verify cluster health:
   ```
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

### Database Recovery

1. Identify the latest snapshot
2. Restore the database from snapshot
3. Verify data integrity
4. Update application configuration if needed

## Testing Schedule

- Monthly: Test EKS cluster recovery
- Quarterly: Full DR test including infrastructure and application recovery
- Annually: Complete failover to secondary region