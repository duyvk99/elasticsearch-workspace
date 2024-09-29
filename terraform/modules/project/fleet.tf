resource "elasticstack_fleet_agent_policy" "fleet_agent_policy" {
  name                 = "${var.name}-fleet-policy"
  namespace            = replace(var.name, "-", "_")
  description          = "${upper(var.name)} Fleet Policy"
  fleet_server_host_id = var.fleet_server_host_id
  monitoring_output_id = var.monitoring_output_id
  data_output_id       = var.data_output_id
  monitor_logs         = true
  monitor_metrics      = true
  skip_destroy         = false
}

resource "elasticstack_fleet_agent_policy" "fleet_3rd_agent_policy" {
  count                = var.enabled_fleet_3rd ? 1 : 0
  name                 = "3rd-${var.environment}-fleet-policy"
  namespace            = replace(var.name, "-", "_")
  description          = "${upper(var.name)} Thirdparty Fleet Policy"
  fleet_server_host_id = var.fleet_server_host_id
  monitoring_output_id = var.monitoring_output_id
  data_output_id       = var.data_output_id
  monitor_logs         = true
  monitor_metrics      = true
  skip_destroy         = false
}

#### The integration policies #####
##### Postgresql #####
resource "elasticstack_fleet_integration_policy" "postgresql_policy" {
  count               = var.postgresql_integration != "" ? 1 : 0
  name                = "${var.name}-postgresql"
  namespace           = replace(var.name, "-", "_")
  description         = "${var.name} Postgresql Integration Policy"
  agent_policy_id     = var.enabled_fleet_3rd ? elasticstack_fleet_agent_policy.fleet_3rd_agent_policy[0].policy_id : elasticstack_fleet_agent_policy.fleet_agent_policy.policy_id
  integration_name    = data.elasticstack_fleet_integration.postgresql_integration.name
  integration_version = data.elasticstack_fleet_integration.postgresql_integration.version

  input {
    input_id = "postgresql-logfile"
    enabled  = false
  }

  input {
    input_id = "postgresql-postgresql/metrics"
  }
}

# ###### Kafka #####
resource "elasticstack_fleet_integration_policy" "kafka_policy" {
  count               = var.kafka_integration != "" ? 1 : 0
  name                = "${var.name}-kafka"
  namespace           = replace(var.name, "-", "_")
  description         = "${upper(var.name)} Kafka Integration Policy"
  agent_policy_id     = var.enabled_fleet_3rd ? elasticstack_fleet_agent_policy.fleet_3rd_agent_policy[0].policy_id : elasticstack_fleet_agent_policy.fleet_agent_policy.policy_id
  integration_name    = data.elasticstack_fleet_integration.kafka_integration.name
  integration_version = data.elasticstack_fleet_integration.kafka_integration.version

  input {
    input_id = "kafka-logfile"
    enabled  = false
  }

  input {
    input_id     = "kafka-kafka/metrics"
    streams_json = null
    vars_json = jsonencode({
      "hosts" : [
        var.kafka_integration
      ],
      "period" : "60s",
      "ssl.certificate_authorities" : []
    })
  }
}

##### Kubernetes #####
resource "elasticstack_fleet_integration_policy" "kubernetes_policy" {
  name                = "${var.name}-kubernetes"
  namespace           = replace(var.name, "-", "_")
  description         = "${upper(var.name)} Kubernetes Integration Policy"
  agent_policy_id     = elasticstack_fleet_agent_policy.fleet_agent_policy.policy_id
  integration_name    = data.elasticstack_fleet_integration.kubernetes_integration.name
  integration_version = data.elasticstack_fleet_integration.kubernetes_integration.version

  input {
    input_id = "kube-state-metrics-kubernetes/metrics"
    streams_json = jsonencode({
      "kubernetes.state_container" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "add_resource_metadata_config" : "add_resource_metadata:\n  namespace:\n    include_labels: [\"kubernetes.labels.env\"]\n  node:\n    include_labels: [\"kubernetes.labels.env\"]\n  deployment: \n    include_labels: [\"kubernetes.labels.env\"]\n",
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_cronjob" : {
        "enabled" : false,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_daemonset" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "processors" : "add_resource_metadata:\n  namespace:\n    include_labels: [\"kubernetes.labels.env\"]\n  node:\n    include_labels: [\"kubernetes.labels.env\"]\n  deployment: \n    include_labels: [\"kubernetes.labels.env\"]\n",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_deployment" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "processors" : "add_resource_metadata:\n  namespace:\n    include_labels: [\"kubernetes.labels.env\"]\n  node:\n    include_labels: [\"kubernetes.labels.env\"]\n  deployment: \n    include_labels: [\"kubernetes.labels.env\"]\n",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_job" : {
        "enabled" : false,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_namespace" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_node" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "processors" : "add_resource_metadata:\n  namespace:\n    include_labels: [\"kubernetes.labels.env\"]\n  node:\n    include_labels: [\"kubernetes.labels.env\"]\n  deployment: \n    include_labels: [\"kubernetes.labels.env\"]\n",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_persistentvolume" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "30s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_persistentvolumeclaim" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "30s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_pod" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "add_resource_metadata_config" : "add_resource_metadata:\n  namespace:\n    include_labels: [\"kubernetes.labels.env\"]\n  node:\n    include_labels: [\"kubernetes.labels.env\"]\n  deployment: \n    include_labels: [\"kubernetes.labels.env\"]\n",
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_replicaset" : {
        "enabled" : false,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_resourcequota" : {
        "enabled" : false,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_service" : {
        "enabled" : false,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_statefulset" : {
        "enabled" : false,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      },
      "kubernetes.state_storageclass" : {
        "enabled" : false,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "kube-state-metrics:8080"
          ],
          "leaderelection" : true,
          "period" : "10s",
          "ssl.certificate_authorities" : []
        }
      }
    })
    vars_json = null
  }

  input {
    input_id = "kube-proxy-kubernetes/metrics"
    enabled  = false
  }

  input {
    input_id = "kube-controller-manager-kubernetes/metrics"
    enabled  = false
  }

  input {
    input_id = "audit-logs-filestream"
    enabled  = false
  }

  input {
    input_id = "kubelet-kubernetes/metrics"
    streams_json = jsonencode({
      "kubernetes.container" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "add_resource_metadata_config" : "add_resource_metadata:\n  namespace:\n    include_labels: [\"kubernetes.labels.env\"]\n  node:\n    include_labels: [\"kubernetes.labels.env\"]\n  deployment: \n    include_labels: [\"kubernetes.labels.env\"]\n",
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "https://$${env.NODE_NAME}:10250"
          ],
          "period" : "10s",
          "ssl.certificate_authorities" : [],
          "ssl.verification_mode" : "none"
        }
      },
      "kubernetes.node" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "https://$${env.NODE_NAME}:10250"
          ],
          "period" : "10s",
          "ssl.certificate_authorities" : [],
          "ssl.verification_mode" : "none"
        }
      },
      "kubernetes.pod" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "add_resource_metadata_config" : "add_resource_metadata:\n  namespace:\n    include_labels: [\"kubernetes.labels.env\"]\n  node:\n    include_labels: [\"kubernetes.labels.env\"]\n  deployment: \n    include_labels: [\"kubernetes.labels.env\"]\n",
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "https://$${env.NODE_NAME}:10250"
          ],
          "period" : "10s",
          "ssl.certificate_authorities" : [],
          "ssl.verification_mode" : "none"
        }
      },
      "kubernetes.system" : {
        "enabled" : true,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "https://$${env.NODE_NAME}:10250"
          ],
          "period" : "10s",
          "ssl.certificate_authorities" : [],
          "ssl.verification_mode" : "none"
        }
      },
      "kubernetes.volume" : {
        "enabled" : false,
        "vars" : {
          "add_metadata" : true,
          "bearer_token_file" : "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "hosts" : [
            "https://$${env.NODE_NAME}:10250"
          ],
          "period" : "10s",
          "ssl.certificate_authorities" : [],
          "ssl.verification_mode" : "none"
        }
      }
    })
    vars_json = null
  }

  input {
    input_id = "kube-apiserver-kubernetes/metrics"
    enabled  = false
  }

  input {
    input_id = "kube-scheduler-kubernetes/metrics"
    enabled  = false
  }

  input {
    input_id = "events-kubernetes/metrics"
    enabled  = false
  }

  input {
    input_id = "container-logs-filestream"
    streams_json = jsonencode({
      "kubernetes.container_logs" : {
        "enabled" : true,
        "vars" : {
          "additionalParsersConfig" : "# - ndjson:\n#     target: json\n#     ignore_decoding_error: true\n- multiline:\n    type: pattern\n    pattern: '^([12]\\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\\d|3[01]))'\n    negate: true\n    match: after",
          "condition" : "(match($${kubernetes.labels.env}, '${var.environment}') == true or $${kubernetes.namespace} == 'ingress-nginx') and $${kubernetes.container.name} != 'healthcheck'",
          "containerParserFormat" : "auto",
          "containerParserStream" : "all",
          "custom" : "logging.metrics.enabled: false",
          "data_stream.dataset" : "kubernetes.container_logs",
          "paths" : [
            "/var/log/containers/*$${kubernetes.container.id}.log"
          ],
          "processors" : "- drop_event:\n    when:\n      contains:\n        message: \"/health/readiness\"\n- include_fields:\n    fields: [\"container.image.name\", \"kubernetes.pod.name\", \"kubernetes.namespace\", \"kubernetes.container.name\", \"kubernetes.labels.env\", \"kubernetes.deployment.name\", \"message\", \"data_stream\", \"event.ingested\"]",
          "symlinks" : true
        }
      }
    })
    vars_json = null
  }
}

###### APM #####
resource "elasticstack_fleet_integration_policy" "apm_policy" {
  count               = var.enabled_apm ? 1 : 0
  name                = "${var.name}-apm"
  namespace           = replace(var.name, "-", "_")
  description         = "${upper(var.name)} APM Integration Policy"
  agent_policy_id     = elasticstack_fleet_agent_policy.fleet_agent_policy.policy_id
  integration_name    = data.elasticstack_fleet_integration.apm_integration.name
  integration_version = data.elasticstack_fleet_integration.apm_integration.version

  input {
    enabled      = true
    input_id     = "apmserver-apm"
    streams_json = "{}"
    vars_json    = "{\"anonymous_allow_agent\":[\"rum-js\",\"js-base\",\"iOS/swift\"],\"anonymous_allow_service\":[],\"anonymous_enabled\":true,\"anonymous_rate_limit_event_limit\":300,\"anonymous_rate_limit_ip_limit\":1000,\"api_key_enabled\":false,\"api_key_limit\":100,\"capture_personal_data\":true,\"enable_rum\":true,\"expvar_enabled\":false,\"host\":\"${var.apm_host}\",\"idle_timeout\":\"45s\",\"java_attacher_enabled\":false,\"max_connections\":0,\"max_event_bytes\":307200,\"max_header_bytes\":1048576,\"pprof_enabled\":false,\"read_timeout\":\"3600s\",\"rum_allow_headers\":[],\"rum_allow_origins\":[\"\\\"*\\\"\"],\"rum_exclude_from_grouping\":\"\\\"^/webpack\\\"\",\"rum_library_pattern\":\"\\\"node_modules|bower_components|~\\\"\",\"shutdown_timeout\":\"30s\",\"tail_sampling_enabled\":false,\"tail_sampling_interval\":\"1m\",\"tail_sampling_policies\":\"- sample_rate: 0.1\\n\",\"tail_sampling_storage_limit\":\"3GB\",\"tls_cipher_suites\":[],\"tls_curve_types\":[],\"tls_enabled\":false,\"tls_supported_protocols\":[\"TLSv1.1\",\"TLSv1.2\",\"TLSv1.3\"],\"url\":\"http://${var.apm_host}\",\"write_timeout\":\"30s\"}"
  }

}