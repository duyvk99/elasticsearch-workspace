resource "elasticstack_kibana_action_connector" "logs_connector_webhook" {
  space_id = elasticstack_kibana_space.kibana_space.space_id

  name = "logs-webhook"
  config = jsonencode({
    url     = var.logs_webhook
    method  = "post"
    hasAuth = false
  })
  secrets = jsonencode({})

  connector_type_id = ".webhook"
}

resource "elasticstack_kibana_action_connector" "metrics_connector_webhook" {
  space_id = elasticstack_kibana_space.kibana_space.space_id

  name = "metrics-webhook"
  config = jsonencode({
    url     = var.metrics_webhook
    method  = "post"
    hasAuth = false
  })
  secrets = jsonencode({})

  connector_type_id = ".webhook"
}
