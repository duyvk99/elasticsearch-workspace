#### PROJECT #####
module "project" {
  source = "../../../modules/project"

  api_key                = var.api_key
  elasticsearch_endpoint = var.elasticsearch_endpoint
  kibana_endpoint        = var.kibana_endpoint

  name        = local.prefix
  project     = var.project_name
  environment = var.environment

  ##### Fleet #####
  enabled_apm          = var.enabled_apm
  enabled_fleet_3rd    = var.enabled_fleet_3rd
  monitoring_output_id = var.monitoring_output_id
  fleet_server_host_id = var.fleet_server_host_id
  data_output_id       = var.data_output_id

  ##### Integration #####
  kafka_integration      = var.kafka_integration
  postgresql_integration = var.postgresql_integration

  ##### Logs Config #####
  additional_dataview = var.additional_dataview
  additional_filter   = var.additional_filter

  #### Connector Config ####
  enabled_metric  = var.enabled_metric
  bot_token       = var.bot_token
  metric_chat_id  = var.metric_chat_id
  metrics_webhook = var.metrics_webhook
  log_chat_id     = var.log_chat_id
  logs_webhook    = var.logs_webhook

}