
data "elasticstack_fleet_integration" "postgresql_integration" {
  name = "postgresql"
}

data "elasticstack_fleet_integration" "kafka_integration" {
  name = "kafka"
}

data "elasticstack_fleet_integration" "kubernetes_integration" {
  name = "kubernetes"
}


data "elasticstack_fleet_integration" "apm_integration" {
  name = "apm"
}
