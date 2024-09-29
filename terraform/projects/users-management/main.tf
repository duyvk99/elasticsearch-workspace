module "user-management" {
  source = "../../modules/users-management"

  api_key                = var.api_key
  elasticsearch_endpoint = var.elasticsearch_endpoint
  kibana_endpoint        = var.kibana_endpoint

  teams_map_users = local.teams_map_users

  custom_kibana_space  = local.custom_kibana_space
  default_kibana_space = local.default_kibana_space
}
