# ECR Module

[![workflow](https://github.com/telia-oss/terraform-aws-ecr/workflows/workflow/badge.svg)](https://github.com/telia-oss/terraform-aws-ecr/actions)

This module creates a repository on ECR (and associated policies) that other accounts can be given push and pull access to.

- Creates a repository on ECR
- Creates a policy to allow other accounts push and pull access
- Creates a lifecycle policy that expires images as follows:
  1. Retain only X untagged images (configurable, default is 1). This rule in itself should stop most issues.
  2. For each Element in the new variable protected_branches (defaults to an empty list), retain only Y (configurable, default is 1) images whose tag starts with each of the elements of protected_branches
  3. Retain only Z images in total (configurable, default is 100).
- Enable/Disable vulnerability scan on image push (default enabled)
