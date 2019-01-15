oc delete deploymentconfigs/splunk-deployment-server deploymentconfigs/splunk-indexer dc/splunk-forwarder
oc delete svc/splunk-indexer svc/splunk-deployment-server routes/splunk-indexer routes/splunk-deployment-server
oc delete template splunk-ephemeral
oc create -f splunk-cluster-template.yaml 
oc new-app --template splunk-ephemeral
