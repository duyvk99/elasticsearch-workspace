
variable "logs_webhook" {
}

variable "metrics_webhook" {
}

variable "bot_token" {
}

variable "metric_chat_id" {
}

variable "log_chat_id" {
}

variable "additional_filter" {
  default = []
}

variable "additional_dataview" {
  default = []
}

variable "tags" {
  default = {}
}

##### Fleet #####
variable "enabled_fleet_3rd" {
  type    = bool
  default = false
}

variable "fleet_server_host_id" {

}

variable "monitoring_output_id" {

}

variable "data_output_id" {

}
##### Integration #####
variable "kafka_integration" {
  default = ""
}

variable "postgresql_integration" {
  default = ""
}

variable "api_key" {

}

variable "elasticsearch_endpoint" {

}

variable "kibana_endpoint" {

}

variable "enabled_metric" {
  type = bool
}

variable "enabled_apm" {
  type    = bool
  default = true
}