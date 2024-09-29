# ##### ILM #####
resource "elasticstack_elasticsearch_index_lifecycle" "ilm" {
  name = "${var.name}-ilm-self-managed"

  hot {
    min_age = "1h"
    set_priority {
      priority = 0
    }
    rollover {
      max_primary_shard_size = "30Gb"
      max_age                = "3d"
    }
    readonly {}
  }

  delete {
    min_age = "2d"
    delete {}
  }
}

# Modify Custom Kuberentes Container Logs
resource "elasticstack_elasticsearch_component_template" "conponent_kuberentes_container_logs" {
  name = "logs-kubernetes.container_logs@custom"

  template {
    settings = jsonencode({
      index = {
        lifecycle = {
          name = elasticstack_elasticsearch_index_lifecycle.ilm.name
        },
        default_pipeline = elasticstack_elasticsearch_ingest_pipeline.ingest_pipeline_java.name
      }
    })
  }
}

resource "elasticstack_elasticsearch_component_template" "conponent_traces_apm_custom" {
  name = "traces-apm@custom"

  template {
    settings = jsonencode({
      index = {
        lifecycle = {
          name = elasticstack_elasticsearch_index_lifecycle.ilm.name
        }
      }
    })
  }
}
