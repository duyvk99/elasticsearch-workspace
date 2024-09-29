##### Kibana Space #####
resource "elasticstack_kibana_space" "kibana_space" {
  space_id          = "${var.name}-space"
  name              = upper(var.name)
  description       = "${var.name} Space"
  disabled_features = ["ml", "observabilityAIAssistant", "aiAssistantManagementSelection", "rulesSettings", "maintenanceWindow", "osquery", "siem", "securitySolutionCases", "securitySolutionAssistant", "enterpriseSearch", "guidedOnboardingFeature", "advancedSettings", "fleetv2"]
  initials          = ":)"
}
