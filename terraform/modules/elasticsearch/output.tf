output "elasticsearch_ingest_pipeline_id" {
  value = elasticstack_elasticsearch_ingest_pipeline.ingest_pipeline_java.id
}

output "elasticstack_elasticsearch_index_lifecycle_id" {
  value = elasticstack_elasticsearch_index_lifecycle.ilm.id
}