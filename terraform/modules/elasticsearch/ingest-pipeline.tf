##### Ingest Pipeline #####
data "elasticstack_elasticsearch_ingest_processor_grok" "grok" {
  field = "message"
  patterns = [
    "%%{TIMESTAMP_ISO8601}\\s\\[%%{DATA:trace_id}\\]\\s\\[%%{DATA:ip_addr}\\]\\s\\[%%{DATA:thread}\\]\\s\\[%%{DATA:marker}\\]\\s%%{DATA:request_id}\\s\\[%%{DATA:traceid}\\/%%{DATA:spanid}\\]\\s%%{DATA:status}\\s+%%{DATA:class}\\s-\\s%%{GREEDYDATA:rest}(?<throwable>(.|\\r|\\n)*)"
  ]
  ignore_failure = true
}

data "elasticstack_elasticsearch_ingest_processor_remove" "remove_ip_addr" {
  field = ["ip_addr"]
  if    = "ctx.ip_addr == ''"
}

data "elasticstack_elasticsearch_ingest_processor_remove" "remove_request_id" {
  field = ["request_id"]
  if    = "ctx.request_id == ''"
}

data "elasticstack_elasticsearch_ingest_processor_remove" "remove_throwable" {
  field = ["throwable"]
  if    = "ctx.throwable == ''"
}

data "elasticstack_elasticsearch_ingest_processor_remove" "remove_marker" {
  field = ["marker"]
  if    = "ctx.marker == ''"
}

resource "elasticstack_elasticsearch_ingest_pipeline" "ingest_pipeline_java" {
  name = "logs-java_buz_app-self-managed"

  processors = [
    data.elasticstack_elasticsearch_ingest_processor_grok.grok.json,
    data.elasticstack_elasticsearch_ingest_processor_remove.remove_ip_addr.json,
    data.elasticstack_elasticsearch_ingest_processor_remove.remove_request_id.json,
    data.elasticstack_elasticsearch_ingest_processor_remove.remove_throwable.json,
    data.elasticstack_elasticsearch_ingest_processor_remove.remove_marker.json
  ]
}
