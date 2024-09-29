terraform {
  required_version = ">= 1.0.0"
  required_providers {
    elasticstack = {
      source  = "elastic/elasticstack"
      version = "0.11.4"
    }
  }
}

provider "elasticstack" {
  elasticsearch {
    api_key   = var.api_key
    endpoints = [var.elasticsearch_endpoint]
  }
  kibana {
    endpoints = [var.kibana_endpoint]
  }
}

provider "aws" {
  region  = var.region
  profile = "kz_uat"
}
