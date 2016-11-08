#!/bin/bash -x


IP=$(grep "\s${HOSTNAME}$" /etc/hosts | head -n 1 | awk '{print $1}')


cat /opt/kafka/config/server.properties.tmpl | sed \
  -e "s|{{KAFKA_ADVERTISED_LISTENERS}}|${KAFKA_ADVERTISED_LISTENERS:-$IP}|g" \
  -e "s|{{ZOOKEEPER_CONNECT}}|${ZOOKEEPER_CONNECT}|g" \
   > /opt/kafka/config/server.properties

echo "Starting kafka"
exec /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
