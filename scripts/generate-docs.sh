#!/bin/bash

# Generate Terraform documentation
echo "Generating Terraform documentation..."
terraform-docs markdown table --output-file docs/terraform-modules.md .

# Generate infrastructure diagram
echo "Generating infrastructure diagram..."
terraform graph | dot -Tpng > docs/infrastructure-diagram.png

echo "Documentation generation complete!"