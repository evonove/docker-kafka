#!/bin/bash -x


IP=$(grep "\s${HOSTNAME}$" /etc/hosts | head -n 1 | awk '{print $1}')
DEFAULT_ADVERTISED_LISTENER=PLAINTEXT://$IP:9092

cat /opt/kafka/config/server.properties.tmpl | sed \
  -e "s|{{KAFKA_ADVERTISED_LISTENERS}}|${KAFKA_ADVERTISED_LISTENERS-$DEFAULT_ADVERTISED_LISTENER}|g" \
  -e "s|{{ZOOKEEPER_CONNECT}}|${ZOOKEEPER_CONNECT}|g" \
  -e "s|{{ZOOKEEPER_CONNECTION_TIMEOUT_MS}}|${ZOOKEEPER_CONNECTION_TIMEOUT_MS:-6000}|g" \
  -e "s|{{KAFKA_MAX_REQUEST_SIZE}}|${KAFKA_MAX_REQUEST_size:-1048576}|g" \
  -e "s|{{KAFKA_MESSAGE_MAX_BYTES}}|${KAFKA_MESSAGE_MAX_BYTES:-1000012}|g" \
  -e "s|{{KAFKA_MAX_PARTITION_FETCH_BYTES}}|${KAFKA_MAX_PARTITION_FETCH_BYTES}:-1048576}|g" \
   > /opt/kafka/config/server.properties

echo "Starting kafka"
exec /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
