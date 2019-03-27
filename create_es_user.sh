#!/bin/bash
# Creating the Kibana ES user

KIBANA_USER="kibana-finance"

echo "Creating the relevant Kibana users and roles for Elasticsearch [$KIBANA_USER]."
echo "Enter the Kibana user password"
read -s PW_KIBANA
echo "Enter the password for user 'elastic'"
read -s PW_ELASTIC

curl -k -X PUT "https://localhost:9200/_xpack/security/role/kibana_system_finance?pretty" -u elastic:$PW_ELASTIC -H "Content-Type: application/json" -d @- << EOF
{
    "cluster" : [
      "monitor",
      "manage_index_templates",
      "cluster:admin/xpack/monitoring/bulk"
    ],
    "indices" : [
      {
        "names" : [
          ".kibana-finance"
        ],
        "privileges" : [
          "all"
        ],
        "field_security" : {
          "grant" : [ "*" ]
        }
      }
    ],
    "run_as" : [ ],
    "metadata" : {
      "project": "finance"
     },
    "transient_metadata" : {
      "enabled" : true
    }
  }
EOF

curl -k -X PUT "https://localhost:9200/_xpack/security/role/kibana_user_finance?pretty" -u elastic:$PW_ELASTIC -H "Content-Type: application/json" -d @- << EOF
{
    "cluster" : [ ],
    "indices" : [
      {
        "names" : [
          ".kibana-finance"
        ],
        "privileges" : [
          "manage",
          "read",
          "index",
          "delete"
        ],
        "field_security" : {
          "grant" : [ "*" ]
        }
      }
    ],
    "run_as" : [ ],
    "metadata" : {
      "project": "finance"
     },
    "transient_metadata" : {
      "enabled" : true
    }
  }
EOF

curl -k -X PUT "https://localhost:9200/_xpack/security/role/finance_user?pretty" -u elastic:$PW_ELASTIC -H "Content-Type: application/json" -d @- << EOF
{
    "cluster": [ ],
    "indices": [
      {
        "names": [
          "project.finance.7cd1e189-f265-11e8-92e6-005056b35471-*"
        ],
        "privileges": [
          "read",
          "view_index_metadata"
        ],
        "field_security": {
          "grant": [
            "*"
          ],
          "except": [
            "beat.version"
          ]
        }
      }
    ],
    "run_as": [ ],
    "metadata": {
      "project": "finance"
    },
    "transient_metadata": {
      "enabled": true
    }
}
EOF

# kibana user
curl -k -XPUT -u elastic:$PW_ELASTIC "https://localhost:9200/_xpack/security/user/$KIBANA_USER" -H "Content-Type: application/json" -d @- << EOF
{
  "password" : "$PW_KIBANA",
  "roles" : [ "kibana_system_finance", "monitoring_user" ],
  "full_name" : "$KIBANA_USER",
  "email" : "Antony.Thilagar@t-systems.com",
  "metadata" : {
    "project" : "$KIBANA_USER"
  }
}
EOF

curl -k -X PUT "https://localhost:9200/_xpack/security/role/reporting_user_finance?pretty" -u elastic:$PW_ELASTIC -H "Content-Type: application/json" -d @- << EOF
{
    "cluster" : [ ],
    "indices" : [
      {
        "names" : [
          ".reporting-finance*"
        ],
        "privileges" : [
          "read",
          "write"
        ],
        "field_security" : {
          "grant" : [ "*" ]
        }
      }
    ],
    "run_as" : [ ],
    "metadata" : {
      "project": "finance"
     },
    "transient_metadata" : {
      "enabled" : true
    }
  }
EOF
