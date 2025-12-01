locals {
  tags = {
    project     = var.name
    environment = var.environment
    cost-center = "engineering"
    auto-stop   = "true"
  }
}