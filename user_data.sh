#!/bin/bash
set -e

yum update -y
yum install -y httpd mysql aws-cli jq

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Get database credentials from Secrets Manager
if ! DB_SECRET=$(aws secretsmanager get-secret-value --secret-id ${secret_arn} --region eu-west-2 --query SecretString --output text 2>/dev/null); then
    echo "Failed to retrieve database secret" >&2
    exit 1
fi

DB_ENDPOINT=$(echo "$DB_SECRET" | jq -r .host 2>/dev/null || echo "unknown")
DB_NAME=$(echo "$DB_SECRET" | jq -r .dbname 2>/dev/null || echo "unknown")

# Create a simple index page without sensitive information
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Application Server</title>
</head>
<body>
    <h1>Application Server Running</h1>
    <p>Server: $(hostname)</p>
    <p>Database Connection: Configured</p>
    <p>Status: Healthy</p>
</body>
</html>
EOF

# Set proper permissions
chown apache:apache /var/www/html/index.html