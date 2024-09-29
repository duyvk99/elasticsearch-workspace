# resource "elasticstack_elasticsearch_snapshot_repository" "s3_repo" {
#   name = "${var.name}-s3-snapshot-repo"

#   s3 {
#     bucket = aws_s3_bucket.s3_bucket.id
#     client = "default"
#     compress = true
#   }
# }

# resource "elasticstack_elasticsearch_snapshot_lifecycle" "slm_policy" {
#   name = "daily-snapshot-logs-${var.name}"

#   schedule      = "0 0 0 * * ?"
#   snapshot_name = "<${var.name}-logs-{now/d}>"
#   repository    = elasticstack_elasticsearch_snapshot_repository.s3_repo.name

#   indices              = [".ds-logs-kubernetes.container_logs-itl_stg-*"]
#   ignore_unavailable   = false
#   include_global_state = false

#   expire_after = "30d"
#   min_count    = 5
#   max_count    = 50
# }