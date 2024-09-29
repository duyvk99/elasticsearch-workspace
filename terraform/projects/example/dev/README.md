# Terraform ELasticStack - Project Management
## Requirements
- Install Terraform.
- Update file **terraform-backend\.tf** for right remote state

## Setup
- Replace your terraform variables and run the command below to create resources in Vault. 
```
cd terraform/projects/<PROJECT_NAME>/<ENVIRONMENT>
mv terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -out tf.plan
terraform show -no-color tf.plan > tfplan.txt
terraform apply
```
## Inputs
---

| Name                   | Description                                                                                  |     Type     | Default | Required |
|------------------------|----------------------------------------------------------------------------------------------|:------------:|:-------:|:--------:|
| api_key                | An Elasticsearch API key to use instead of ELASTICSEARCH_USERNAME and ELASTICSEARCH_PASSWORD |    string    |         |    yes   |
| elasticsearch_endpoint | A comma separated list of Elasticsearch hosts to connect to                                  |    string    |         |    yes   |
| kibana_endpoint        | The Kibana host to connect to                                                                |    string    |         |    yes   |
| enabled_apm            | Enable APM                                                                                   |     bool     |   true  |          |
| enabled_metric         | Enable Metric                                                                                |     bool     |         |    yes   |
| enabled_fleet_3rd      | Create New Fleet for 3RD Only                                                                |     bool     |  false  |          |
| fleet_server_host_id   | The identifier for the Fleet server host.                                                    |    string    |         |    yes   |
| monitoring_output_id   | The identifier for monitoring output.                                                        |    string    |         |    yes   |
| data_output_id         | The identifier for the data output.                                                          |    string    |         |    yes   |
| kafka_integration      | Kafka endpoint to connect (Enabled kafka integration as well)                                |    string    |         |          |
| postgresql_integration | Postgresql Endpoint to connect (Enabled Postgres integration as well)                        |    string    |         |          |
| additional_filter      | Add additional filter for UI View                                                            | list(string) |         |          |
| additional_dataview    | Add additional data view for log searching                                                   | list(string) |         |          |
| logs_webhook           | Send logs error alerts.                                                                      |    string    |         |    yes   |
| metrics_webhook        | Send metrics alerts.                                                                         |    string    |         |    yes   |
| bot_token              | Telegram Bot Token.                                                                          |    string    |         |    yes   |
| log_chat_id            | Telegram Chat ID Group for logs alerts.                                                      |    string    |         |    yes   |
| metric_chat_id         | Telegram Chat ID Group for metrics alerts.                                                   |    string    |         |    yes   |
| demo_log_chat_id       | Telegram Chat ID Group for demo logs alerts.                                                 |    string    |         |          |
| tags                   |                                                                                              |      any     |    {}   |          |