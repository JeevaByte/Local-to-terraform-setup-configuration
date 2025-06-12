package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformInfrastructure(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		VarFiles:     []string{"terraform.tfvars"},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vpcId := terraform.Output(t, terraformOptions, "csi_vpc_id")
	eksClusterName := terraform.Output(t, terraformOptions, "eks_cluster_name")
	
	assert.NotEmpty(t, vpcId, "VPC ID should not be empty")
	assert.NotEmpty(t, eksClusterName, "EKS cluster name should not be empty")
}