variable "name" {
}
variable "region" {
  default = "ap-southeast-1"
  type    = string
}
variable "tags" {
  default = {}
}

variable "enable_snapshot" {
  default = false
  type    = bool
}

variable "environment" {
  type = string
}

variable "api_key" {

}

variable "elasticsearch_endpoint" {

}

variable "kibana_endpoint" {

}