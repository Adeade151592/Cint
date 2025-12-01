# Terratest Validation

## Prerequisites
- Go 1.21+
- AWS credentials configured
- Terraform installed

## Running Tests

```bash
# Run all tests
make test

# Run quick tests (without full deployment)
make test-fast

# Clean test cache
make clean
```

## Test Coverage
- Infrastructure deployment validation
- Load balancer accessibility
- Auto Scaling Group configuration
- Security group validation
- VPC and networking setup