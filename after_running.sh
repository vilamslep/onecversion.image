#!/bin/bash
echo "Enter tunnel target host (where need to send request):"
read targethost

echo "Enter tunnel target port (where need to send request):"
read targetport

echo "Enter tunnel port (port which need to open for forwarding):"
read tunnelport

ssh -fCNR $tunnelport:$targethost:$targetport -p 22222 root@localhost

docker exec kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:9092 --if-not-exists --create --topic raw --partitions 1 --replication-factor 1
