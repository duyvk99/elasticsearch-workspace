resource "elasticstack_kibana_import_saved_objects" "tags" {
  space_id = elasticstack_kibana_space.kibana_space.space_id

  overwrite = true
  file_contents = templatefile("${path.module}/template-saved-objects/tags.tpl", {
    project     = var.project
    environment = var.environment
  })
}

resource "elasticstack_kibana_import_saved_objects" "data_view" {
  space_id  = elasticstack_kibana_space.kibana_space.space_id
  overwrite = true

  file_contents = templatefile("${path.module}/template-saved-objects/data-view.tpl", {
    project             = var.project
    environment         = var.environment
    additional_dataview = var.additional_dataview
  })
}

resource "elasticstack_kibana_import_saved_objects" "logs_view" {
  space_id  = elasticstack_kibana_space.kibana_space.space_id
  overwrite = true

  file_contents = templatefile("${path.module}/template-saved-objects/logs-view.tpl", {
    project           = var.project
    environment       = var.environment
    additional_filter = var.additional_filter
  })

  depends_on = [
    elasticstack_kibana_import_saved_objects.data_view,
    elasticstack_kibana_import_saved_objects.tags
  ]
}
