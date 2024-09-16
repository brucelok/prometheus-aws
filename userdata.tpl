#!/bin/bash
# Set Prometheus version here
PROMETHEUS_VERSION="2.54.1"

# Update and install the packages
apt-get update -y
apt-get install -y wget tar apt-transport-https software-properties-common

# Download and install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar -xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
mv prometheus-${PROMETHEUS_VERSION}.linux-amd64 /etc/prometheus