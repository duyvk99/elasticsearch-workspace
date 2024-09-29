# Terraform Elastic - Pipeline & Snapshot Management
## Requirements
- Install Terraform.
- Update file **terraform-backend\.tf** for right remote state

```
cd elasticsearch/projects/users-management
mv terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -out tf.plan
terraform show -no-color tf.plan > tfplan.txt
terraform apply
```

## Notes Snapshot
- **Run on every master and data node**
```
kubectl --context o11y-system -n elastic-stack exec -it o11y-system-es-master-0 sh
bin/elasticsearch-keystore add s3.client.default.access_key
bin/elasticsearch-keystore add s3.client.default.secret_key
```

- Run on Dev Tools to Reload update keystore
```
POST _nodes/reload_secure_settings
{
  "secure_settings_password": "" 
}
```


## Inputs
---

| Name                   | Description                                                                                  |     Type    | Default                            | Required |
|------------------------|----------------------------------------------------------------------------------------------|:-----------:|------------------------------------|----------|
| api_key                | An Elasticsearch API key to use instead of ELASTICSEARCH_USERNAME and ELASTICSEARCH_PASSWORD |    string   |                                    |    yes   |
| elasticsearch_endpoint | A comma separated list of Elasticsearch hosts to connect to                                  |    string   |                                    |    yes   |
| kibana_endpoint        | The Kibana host to connect to                                                                |    string   |                                    |    yes   |

