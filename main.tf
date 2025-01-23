terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = "= 1.10.4"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_opensearch_domain" "open_search_domain" {
  domain_name    = "open-search-example" # Replace with your desired domain name
  engine_version = "OpenSearch_2.17"     # Use the latest version or the one you prefer

  cluster_config {
    instance_type = "t3.small.search"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10 # Adjust size as needed
    volume_type = "gp2"
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true

    master_user_options {
      master_user_name     = var.master_user_name     # Replace as needed
      master_user_password = var.master_user_password # Use a secure password
    }
  }

  domain_endpoint_options {
    enforce_https = true
  }

  access_policies = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "es:*",
          "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/open-search-example/*"
        }
      ]
    }
  POLICY
}
