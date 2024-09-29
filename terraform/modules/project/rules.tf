######### LOGS ##########
resource "elasticstack_kibana_alerting_rule" "logs_rule" {
  for_each = toset(setunion(var.additional_filter, [var.project]))
  space_id = elasticstack_kibana_space.kibana_space.space_id
  enabled  = true

  name        = "[${upper(each.value)}-${upper(var.environment)}] Logs Alerts"
  consumer    = "alerts"
  notify_when = "onActiveAlert"
  params = jsonencode({
    threshold                  = [0]
    thresholdComparator        = ">"
    size                       = 20
    timeWindowSize             = 1
    timeWindowUnit             = "m",
    timeField                  = "@timestamp",
    searchType                 = "searchSource"
    aggType                    = "count"
    groupBy                    = "all"
    excludeHitsFromPreviousRun = true
    searchConfiguration = {
      index = "logs-${var.name}-data-view-id"
      query = "status:ERROR AND kubernetes.labels.env:${each.value}-${var.environment}"
    }
  })

  rule_type_id = ".es-query"
  interval     = "1m"

  actions {
    id = elasticstack_kibana_action_connector.logs_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"%{if strcontains(each.value, "demo")}${var.demo_log_chat_id}%{else}${var.log_chat_id}%{endif}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": [{{{context.hits}}}]\n}"
    })
    group = "query matched"
  }

  tags = ["env:${var.environment}", "project:${each.value}", "type:logs"]

  depends_on = [
    elasticstack_kibana_import_saved_objects.data_view
  ]
}

########## K8S ##########
resource "elasticstack_kibana_alerting_rule" "node_cpu_rule" {
  count    = var.enabled_metric ? 1 : 0
  space_id = elasticstack_kibana_space.kibana_space.space_id
  enabled  = true

  name        = "[${upper(var.environment)}][K8S][Node] High CPU Usage"
  consumer    = "alerts"
  notify_when = "onActionGroupChange"
  params = jsonencode({
    alertOnGroupDisappear = true
    alertOnNoData         = true
    filterQuery           = "{\"bool\":{\"should\":[{\"bool\":{\"should\":[{\"term\":{\"data_stream.dataset\":{\"value\":\"kubernetes.node\"}}}],\"minimum_should_match\":1}},{\"bool\":{\"should\":[{\"term\":{\"data_stream.dataset\":{\"value\":\"kubernetes.state_node\"}}}],\"minimum_should_match\":1}}],\"minimum_should_match\":1}}"
    filterQueryText       = "data_stream.dataset:\"kubernetes.node\" or data_stream.dataset : \"kubernetes.state_node\" "
    groupBy = [
      "kubernetes.node.name"
    ]
    aggType             = "custom"
    thresholdComparator = ">"
    threshold           = [85]
    timeWindowSize      = 10
    timeWindowUnit      = "m"
    criteria = [{
      "aggType" : "custom",
      "comparator" : ">",
      "customMetrics" : [
        {
          "aggType" : "avg",
          "field" : "kubernetes.node.cpu.usage.nanocores",
          "name" : "A"
        },
        {
          "aggType" : "max",
          "field" : "kubernetes.node.cpu.allocatable.cores",
          "name" : "B"
        }
      ],
      "equation" : "A*100/(B*1000000000)",
      "threshold" : [85],
      "timeSize" : 10,
      "timeUnit" : "m"
    }]
    sourceId = "default"
  })

  rule_type_id = "metrics.alert.threshold"
  interval     = "10m"

  actions {
    id = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"${var.metric_chat_id}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": {\n        \"rule_name\": \"{{{rule.name}}}\",\n        \"value\": \"{{{context.value.condition0}}}%\",\n        \"instance\": \"{{context.group}}\",\n        \"env\": \"common-${var.environment}\",\n        \"state\": \"{{{context.alertState}}}\"\n    }\n}"
    })
    group = "metrics.threshold.fired"
  }

  actions {
    id = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"${var.metric_chat_id}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": {\n        \"rule_name\": \"{{{rule.name}}}\",\n        \"value\": \"{{{context.value.condition0}}}%\",\n        \"instance\": \"{{context.group}}\",\n        \"env\": \"common-${var.environment}\",\n        \"state\": \"{{{context.alertState}}}\"\n    }\n}"
    })
    group = "recovered"
  }

  tags = ["env:${var.environment}", "project:common", "type:k8s", "resource:cpu", "service:instance"]
}

resource "elasticstack_kibana_alerting_rule" "node_mem_rule" {
  count = var.enabled_metric ? 1 : 0

  space_id = elasticstack_kibana_space.kibana_space.space_id
  enabled  = true

  name        = "[${upper(var.environment)}][K8S][Node] Memory Pressure"
  consumer    = "alerts"
  notify_when = "onActionGroupChange"
  params = jsonencode({
    alertOnGroupDisappear = true
    alertOnNoData         = true
    filterQuery           = "{\"bool\":{\"should\":[{\"bool\":{\"should\":[{\"term\":{\"data_stream.dataset\":{\"value\":\"kubernetes.node\"}}}],\"minimum_should_match\":1}},{\"bool\":{\"should\":[{\"term\":{\"data_stream.dataset\":{\"value\":\"kubernetes.state_node\"}}}],\"minimum_should_match\":1}}],\"minimum_should_match\":1}}"
    filterQueryText       = "data_stream.dataset:\"kubernetes.node\" or data_stream.dataset : \"kubernetes.state_node\" "
    groupBy = [
      "kubernetes.node.name"
    ]
    aggType             = "custom"
    thresholdComparator = ">"
    threshold           = [85]
    timeWindowSize      = 10
    timeWindowUnit      = "m"
    criteria = [{
      "aggType" : "custom",
      "comparator" : ">",
      "customMetrics" : [
        {
          "aggType" : "avg",
          "field" : "kubernetes.node.memory.usage.bytes",
          "name" : "A"
        },
        {
          "aggType" : "max",
          "field" : "kubernetes.node.memory.capacity.bytes",
          "name" : "B"
        }
      ],
      "equation" : "A*100/B",
      "threshold" : [90],
      "timeSize" : 10,
      "timeUnit" : "m"
    }]
    sourceId = "default"
  })

  rule_type_id = "metrics.alert.threshold"
  interval     = "10m"

  actions {
    id = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"${var.metric_chat_id}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": {\n        \"rule_name\": \"{{{rule.name}}}\",\n        \"value\": \"{{{context.value.condition0}}}%\",\n        \"instance\": \"{{context.group}}\",\n        \"env\": \"common-${var.environment}\",\n        \"state\": \"{{{context.alertState}}}\"\n    }\n}"
    })
    group = "metrics.threshold.fired"
  }

  actions {
    id = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"${var.metric_chat_id}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": {\n        \"rule_name\": \"{{{rule.name}}}\",\n        \"value\": \"{{{context.value.condition0}}}%\",\n        \"instance\": \"{{context.group}}\",\n        \"env\": \"common-${var.environment}\",\n        \"state\": \"{{{context.alertState}}}\"\n    }\n}"
    })
    group = "recovered"
  }

  tags = ["env:${var.environment}", "project:common", "type:k8s", "resource:memory", "service:instance"]
}

resource "elasticstack_kibana_alerting_rule" "pod_mem_rule" {
  count = var.enabled_metric ? 1 : 0

  space_id = elasticstack_kibana_space.kibana_space.space_id
  enabled  = true

  name        = "[${upper(var.environment)}][K8S][Pods] Memory Pressure"
  consumer    = "alerts"
  notify_when = "onActionGroupChange"
  params = jsonencode({
    alertOnGroupDisappear = true
    alertOnNoData         = true
    filterQuery           = "{\"bool\":{\"should\":[{\"wildcard\":{\"kubernetes.labels.env\":{\"value\":\"*-uat\"}}}],\"minimum_should_match\":1}}"
    filterQueryText       = "kubernetes.labels.env:*-${var.environment}"
    groupBy = [
      "kubernetes.node.name"
    ]
    aggType             = "custom"
    thresholdComparator = ">"
    threshold           = [85]
    timeWindowSize      = 10
    timeWindowUnit      = "m"
    criteria = [{
      "aggType" : "custom",
      "comparator" : ">",
      "customMetrics" : [
        {
          "aggType" : "avg",
          "field" : "kubernetes.pod.memory.usage.bytes",
          "name" : "A"
        },
        {
          "aggType" : "max",
          "field" : "kubernetes.container.memory.limit.bytes",
          "name" : "B"
        }
      ],
      "equation" : "A*100/B",
      "threshold" : [90],
      "timeSize" : 10,
      "timeUnit" : "m"
    }]
    sourceId = "default"
  })

  rule_type_id = "metrics.alert.threshold"
  interval     = "10m"

  actions {
    id = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"${var.metric_chat_id}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": {\n        \"rule_name\": \"{{{rule.name}}}\",\n        \"value\": \"{{{context.value.condition0}}}%\",\n        \"instance\": \"{{context.group}}\",     \n        \"env\": \"common-${var.environment}\",\n        \"state\": \"{{{context.alertState}}}\"\n    }\n}"
    })
    group = "metrics.threshold.fired"
  }

  actions {
    id = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"${var.metric_chat_id}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": {\n        \"rule_name\": \"{{{rule.name}}}\",\n        \"value\": \"{{{context.value.condition0}}}%\",\n        \"instance\": \"{{context.group}}\",     \n        \"env\": \"common-${var.environment}\",\n        \"state\": \"{{{context.alertState}}}\"\n    }\n}"
    })
    group = "recovered"
  }

  tags = ["env:${var.environment}", "project:common", "type:k8s", "resource:memory", "service:pod"]
}

##### Third-Party Application #####
resource "elasticstack_kibana_alerting_rule" "kafka_lag_rule" {
  count = var.kafka_integration != "" ? 1 : 0

  space_id = elasticstack_kibana_space.kibana_space.space_id
  enabled  = true

  name        = "[${upper(var.environment)}][3RD][Kafka] High Message Lag"
  consumer    = "alerts"
  notify_when = "onActionGroupChange"
  params = jsonencode({
    alertOnGroupDisappear = true
    alertOnNoData         = true
    filterQuery           = "{\"bool\":{\"should\":[{\"match\":{\"metricset.name\":\"consumergroup\"}}],\"minimum_should_match\":1}}"
    filterQueryText       = "metricset.name: consumergroup"
    groupBy               = ["kafka.topic.name"]
    aggType               = "custom"
    thresholdComparator   = ">"
    threshold             = [1000]
    timeWindowSize        = 10
    timeWindowUnit        = "m"
    criteria = [{
      "aggType" : "sum",
      "comparator" : ">",
      "metric" : "kafka.consumergroup.consumer_lag"
      "threshold" : [1000],
      "timeSize" : 1,
      "timeUnit" : "m"
    }]
    sourceId = "default"
  })

  rule_type_id = "metrics.alert.threshold"
  interval     = "10m"

  actions {
    id = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"${var.metric_chat_id}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": {\n        \"rule_name\": \"{{{rule.name}}}\",\n        \"value\": \"{{{context.value.condition0}}}\",\n        \"instance\": \"{{context.group}}\",\n        \"env\": \"common-${var.environment}\",\n        \"state\": \"{{{context.alertState}}}\"\n    }\n}"
    })
    group = "metrics.threshold.fired"
  }

  actions {
    id = elasticstack_kibana_action_connector.metrics_connector_webhook.connector_id
    params = jsonencode({
      body = "{\n    \"chat_id\": \"${var.metric_chat_id}\",\n    \"bot_token\": \"${var.bot_token}\",\n    \"text_only_msg\": {\n        \"rule_name\": \"{{{rule.name}}}\",\n        \"value\": \"{{{context.value.condition0}}}\",\n        \"instance\": \"{{context.group}}\",\n        \"env\": \"common-${var.environment}\",\n        \"state\": \"{{{context.alertState}}}\"\n    }\n}"
    })
    group = "recovered"
  }

  tags = ["env:${var.environment}", "project:common", "type:3rd", "service:kafka"]
}