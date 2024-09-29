locals {
  list_users  = flatten([for team, users in var.teams_map_users : users])
  list_groups = flatten([for team, users in var.teams_map_users : team])
  teams_map_users = flatten([
    for role, users in var.teams_map_users : [
      for user in users : {
        role     = role
        username = user
      }
    ]
  ])

}

##### Role #####
##### Admin #####
resource "elasticstack_elasticsearch_security_role" "admin_role" {
  name    = "admin"
  cluster = ["all"]

  indices {
    names      = ["*"]
    privileges = ["all"]
  }

  indices {
    names      = ["*"]
    privileges = ["monitor", "read", "view_index_metadata", "read_cross_cluster"]
  }


  applications {
    application = "kibana-.kibana"
    privileges  = ["space_all"]
    resources   = ["space:*"]
  }

  run_as = ["superuser"]

}

resource "elasticstack_elasticsearch_security_role" "backend_role" {
  name = "backend"

  indices {
    names      = ["*"]
    privileges = ["read"]
  }

  applications {
    application = "kibana-.kibana"
    privileges  = ["space_read"]
    resources   = [for space in var.default_kibana_space : "space:${space}-space"]
  }

}

resource "elasticstack_elasticsearch_security_role" "qc_role" {
  name = "qc"

  indices {
    names      = ["*"]
    privileges = ["read"]
  }

  applications {
    application = "kibana-.kibana"
    privileges  = ["space_read"]
    resources   = [for space in var.default_kibana_space : "space:${space}-space"]
  }

}

resource "elasticstack_elasticsearch_security_role" "fresher_role" {
  name = "fresher"

  indices {
    names      = ["*uat*", "*dev*"]
    privileges = ["read"]
  }

  applications {
    application = "kibana-.kibana"
    privileges  = ["space_read"]
    resources   = [for space in var.custom_kibana_space : "space:${space}-space"]
  }
}

##### User #####
resource "elasticstack_elasticsearch_security_user" "user" {
  for_each = { for user in local.teams_map_users : user.username => user }

  username = each.value.username
  password = var.default_password

  roles = [each.value.role]

  depends_on = [
    elasticstack_elasticsearch_security_role.admin_role,
    elasticstack_elasticsearch_security_role.backend_role,
    elasticstack_elasticsearch_security_role.fresher_role,
    elasticstack_elasticsearch_security_role.qc_role
  ]
}