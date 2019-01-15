echo "Creating docker network, so all containers will see each other"
docker network create splunk
echo "Starting deployment server for forwarders"
docker rm splunkdeploymentserver
docker run -d --net splunk \
    --hostname splunkdeploymentserver \
    --name splunkdeploymentserver \
    --publish 8000 \
    --env SPLUNK_ENABLE_DEPLOY_SERVER=true \
    -e 'SPLUNK_START_ARGS=--accept-license' -e 'SPLUNK_PASSWORD=password' \
    splunk/splunk
echo "Starting Splunk Indexer"
docker rm splunkenterprise
docker run -d --net splunk \
    --hostname splunkenterprise \
    --name splunkenterprise \
    --publish 8000 \
    --env SPLUNK_ENABLE_LISTEN=9997 \
    -e 'SPLUNK_START_ARGS=--accept-license' -e 'SPLUNK_PASSWORD=password' \
    splunk/splunk
echo "Starting forwarder, which forwards data to Splunk"
docker rm forwarder
docker run -d --net splunk \
    --name forwarder \
    --hostname forwarder \
    --env SPLUNK_FORWARD_SERVER='splunkenterprise:9997' \
    --env SPLUNK_FORWARD_SERVER_ARGS='-method clone' \
    --env SPLUNK_ADD='udp 1514' \
    --env SPLUNK_DEPLOYMENT_SERVER='splunkdeploymentserver:8089' \
    -e 'SPLUNK_START_ARGS=--accept-license' -e 'SPLUNK_PASSWORD=password' \
    splunk/universalforwarder
