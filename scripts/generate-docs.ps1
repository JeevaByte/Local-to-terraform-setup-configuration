# Generate Terraform documentation
Write-Host "Generating Terraform documentation..."
terraform-docs markdown table --output-file docs/terraform-modules.md .

# Generate infrastructure diagram
Write-Host "Generating infrastructure diagram..."
terraform graph | dot -Tpng -o docs/infrastructure-diagram.png

Write-Host "Documentation generation complete!"