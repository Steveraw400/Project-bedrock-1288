terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80" # safe recent range; supports all current features
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17" # or ">= 2.0, < 3.0" – pins to last stable v2 series
    }

    # If using kubernetes provider separately, pin it too if needed
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35" # compatible with Helm v2
    }
  }

  required_version = ">= 1.9" # modern, but any >=1.5 works
}