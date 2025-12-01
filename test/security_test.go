package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSecurityGroups(t *testing.T) {
	t.Parallel()

	awsRegion := "eu-west-2"
	
	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":        "terratest-security",
			"environment": "test",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	
	// Get security groups
	securityGroups := aws.GetSecurityGroupsByVpc(t, vpcId, awsRegion)
	
	// Verify we have the expected security groups
	var albSg, ec2Sg, rdsSg *aws.SecurityGroup
	for _, sg := range securityGroups {
		if sg.GroupName != nil {
			switch {
			case contains(*sg.GroupName, "alb"):
				albSg = &sg
			case contains(*sg.GroupName, "ec2"):
				ec2Sg = &sg
			case contains(*sg.GroupName, "rds"):
				rdsSg = &sg
			}
		}
	}

	// Verify security groups exist
	assert.NotNil(t, albSg, "ALB security group should exist")
	assert.NotNil(t, ec2Sg, "EC2 security group should exist")
	assert.NotNil(t, rdsSg, "RDS security group should exist")
}

func contains(s, substr string) bool {
	return len(s) >= len(substr) && s[:len(substr)] == substr || 
		   len(s) > len(substr) && s[len(s)-len(substr):] == substr ||
		   (len(s) > len(substr) && s[1:len(substr)+1] == substr)
}