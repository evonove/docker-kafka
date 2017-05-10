#!/bin/bash -x


IP=$(grep "\s${HOSTNAME}$" /etc/hosts | head -n 1 | awk '{print $1}')
DEFAULT_ADVERTISED_LISTENER=PLAINTEXT://$IP:9092
KAFKA_BROKER_ID=$(grep "\s${HOSTNAME}$" /etc/hosts | head -n 1 | awk '{print $3}' | cut -d "-" -f2)

cat /opt/kafka/config/server.properties.tmpl | sed \
  -e "s|{{KAFKA_BROKER_ID}}|${KAFKA_BROKER_ID:--1}|g" \
  -e "s|{{KAFKA_ADVERTISED_LISTENERS}}|${KAFKA_ADVERTISED_LISTENERS-$DEFAULT_ADVERTISED_LISTENER}|g" \
  -e "s|{{ZOOKEEPER_CONNECT}}|${ZOOKEEPER_CONNECT}|g" \
  -e "s|{{ZOOKEEPER_CONNECTION_TIMEOUT_MS}}|${ZOOKEEPER_CONNECTION_TIMEOUT_MS:-6000}|g" \
   > /opt/kafka/config/server.properties

echo "Starting kafka"
exec /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
