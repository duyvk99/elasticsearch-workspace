output "metrics_connector_webhook_id" {
  value = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
}

output "logs_connector_webhook_id" {
  value = elasticstack_kibana_action_connector.logs_connector_webhook.connector_id
}

output "elasticstack_kibana_space_id" {
  value = elasticstack_kibana_space.kibana_space.space_id
}
