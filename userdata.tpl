#!/bin/bash
# Set Prometheus version here
PROMETHEUS_VERSION="2.54.1"

# Update and install the packages
apt-get update -y
apt-get install -y wget tar apt-transport-https software-properties-common net-tools

# Download and install Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar -xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
mv prometheus-${PROMETHEUS_VERSION}.linux-amd64 /etc/prometheus

# Create Prometheus user and directories
useradd --no-create-home --shell /bin/false prometheus
mkdir -p /etc/prometheus /var/lib/prometheus
chown prometheus:prometheus /etc/prometheus /var/lib/prometheus

# copy binaries
cp /etc/prometheus/prometheus /usr/local/bin/
cp /etc/prometheus/promtool /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

# ensure the config file ownership
chown prometheus:prometheus /etc/prometheus/prometheus.yml

# create Prometheus systemd service file
cat <<EOT >> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus/ \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOT

# Start Prometheus service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus

# Install Grafana
# Add Grafana's GPG key and repository
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"

# Update and install Grafana
apt-get update -y
apt-get install -y grafana

# Enable and start Grafana
systemctl enable grafana-server
systemctl start grafana-server