variable "api_key" {
  type = string
}

variable "elasticsearch_endpoint" {
  type = string
}

variable "kibana_endpoint" {
  type = string
}

variable "teams_map_users" {

}

variable "default_password" {
  type    = string
  default = "Hello@123"
}

variable "custom_kibana_space" {

}

variable "default_kibana_space" {

}