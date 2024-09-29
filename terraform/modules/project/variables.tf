variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "logs_webhook" {
  type = string
}

variable "metrics_webhook" {
  type = string
}

variable "bot_token" {
  type = string
}

variable "log_chat_id" {
  type = string
}

variable "metric_chat_id" {
  type = string
}

variable "additional_dataview" {
  default = []
}

variable "additional_filter" {
  default = []
}
##### Fleet #####
variable "enabled_fleet_3rd" {
  type = bool
}
variable "fleet_server_host_id" {
  type = string
}

variable "monitoring_output_id" {
  type = string
}

variable "data_output_id" {
  type = string
}

###### Integration #####
variable "kafka_integration" {
  type = string
}

variable "postgresql_integration" {

}

variable "tags" {
  default = {}
}

variable "api_key" {
  type = string
}

variable "elasticsearch_endpoint" {
  type = string
}

variable "kibana_endpoint" {
  type = string
}

variable "enabled_metric" {
  type = bool
}

variable "demo_log_chat_id" {
  default = ""
}

variable "enabled_apm" {
  type = bool
}

variable "apm_host" {
  default = "0.0.0.0:8200"
}