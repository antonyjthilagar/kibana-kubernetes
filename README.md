# Overview
Kibana setup for kubernetes and openshift.

--> Kibana will access the Elasticsearch cluster via a local haproxy instance.
--> No Elasticsearch coordination node will be used, since X-Pack (including an additional license) would be required.

# Preparation
Elasticsearch:
- Create the Kibana user/roles on Elasticsearch using create_es_user.sh

Kubernetes/Openshift:
- oc adm new-project kibana-finance
- oc create serviceaccount kibana
- oc adm policy add-scc-to-user privileged system:serviceaccount:kibana-finance:kibana
- oc project kibana-finance
- oc create -f haproxy_configmap.yml
- oc create -f kibana_secret.yml
- oc create -f kibana_configmap.yml
- oc create -f nginx_configmap.yml
- oc create -f nginx_secret.yml
- oc create -f nginx_service.json
- oc create -f nginx_route.yml
- oc create -f kibana_nginx_haproxy_deploymentconfig.yml
- oc create -f horizontal_pod_autoscaler.yml
