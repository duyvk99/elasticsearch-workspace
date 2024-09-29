##### ElasticSearch #####
module "elasticsearch" {
  source = "../../modules/elasticsearch"

  api_key                = var.api_key
  kibana_endpoint        = var.kibana_endpoint
  elasticsearch_endpoint = var.elasticsearch_endpoint

  name        = local.prefix
  environment = var.environment

}
