package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestInfrastructure(t *testing.T) {
	t.Parallel()

	awsRegion := "eu-west-2"
	
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"name":        "terratest-cint",
			"environment": "test",
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Test VPC exists
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotEmpty(t, vpcId)

	// Test Load Balancer
	lbDnsName := terraform.Output(t, terraformOptions, "load_balancer_dns_name")
	assert.NotEmpty(t, lbDnsName)

	// Test ALB responds
	url := "http://" + lbDnsName
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Application Server Running", 30, 10*time.Second)

	// Test Auto Scaling Group
	asgName := terraform.Output(t, terraformOptions, "autoscaling_group_name")
	asg := aws.GetAsgByName(t, asgName, awsRegion)
	assert.Equal(t, int64(2), *asg.MinSize)
	assert.Equal(t, int64(4), *asg.MaxSize)

	// Test RDS Cluster exists
	secretArn := terraform.Output(t, terraformOptions, "database_secret_arn")
	assert.NotEmpty(t, secretArn)
}