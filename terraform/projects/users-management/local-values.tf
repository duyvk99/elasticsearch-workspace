locals {
  teams_map_users = {
    "admin" : ["admin"],
    "qc" : ["qc1","qc2"],
    "backend" : ["be1","be2"],
    "fresher" : ["fresher1"]
  }

  # For Guest or Fresher base on your use-case.
  custom_kibana_space  = ["common-uat", "project1-dev", "project2-uat","project3-stg"]

  default_kibana_space = ["common-stg", "project1-dev", "project1-uat", "project1-stg","project2-dev","project2-uat","project2-stg","project3-dev","project3-uat","project3-stg"]

}