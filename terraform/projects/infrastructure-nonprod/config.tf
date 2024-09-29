module "environment" {
  source       = "../../../config/environment"
  project_name = var.project_name
  environment  = var.environment
}

variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "The environment you want to apply (e.g. dev,staging,etc)"
  type        = string
  default     = null
}