# Terraform Elastic - Users Management
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

## Inputs
---

| Name                   | Description                                                                                  |     Type    | Default                            | Required |
|------------------------|----------------------------------------------------------------------------------------------|:-----------:|------------------------------------|----------|
| api_key                | An Elasticsearch API key to use instead of `ELASTICSEARCH_USERNAME` and `ELASTICSEARCH_PASSWORD` |    string   |                                    |    yes   |
| elasticsearch_endpoint | A comma separated list of Elasticsearch hosts to connect to                                  |    string   |                                    |    yes   |
| kibana_endpoint        | The Kibana host to connect to                                                                |    string   |                                    |    yes   |
| teams_map_users        | List User And Roles (Admin, QC, Backend, Fresher)                                            |     any     | <pre><br>{<br>  "devops": ["admin"],<br>  "qc": ["qc"],<br>  "backend": ["backend"],<br>  "fresher": ["fresher"]<br>}</pre>                       |    yes   |
| custom_kibana_space    | Custom space for Guest Views (intern, frehser, guest,...)                                     | map(string) | ["example-dev","application1-uat"] |          |

