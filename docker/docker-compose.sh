#!/bin/bash

set -e

echo "Preparing shared folders and downloading configuration files..."

# Create all necessary shared folders
mkdir -p shared/tempo
mkdir -p shared/prometheus
mkdir -p shared/mimir
mkdir -p shared/loki/chunks
mkdir -p shared/loki/rules
mkdir -p shared/promtail
mkdir -p shared/logs
mkdir -p shared/logs/shoehub
mkdir -p shared/alloy
mkdir -p shared/grafana/provisioning/datasources
mkdir -p shared/grafana/provisioning/dashboards
mkdir -p shared/grafana/dashboards

# Download Tempo configuration
curl -sSL -o shared/tempo/tempo.yml https://raw.githubusercontent.com/deeepak-tyagii/monitoring-observability-ai-agents/refs/heads/main/tempo/tempo.yml

# Download Prometheus configuration
curl -sSL -o shared/prometheus/prometheus.yml https://raw.githubusercontent.com/deeepak-tyagii/monitoring-observability-ai-agents/refs/heads/main/prometheus/prometheus.yml

# Download Alloy configuration
curl -sSL -o shared/alloy/config.alloy https://raw.githubusercontent.com/deeepak-tyagii/monitoring-observability-ai-agents/refs/heads/main/alloy/config.alloy

# Download Promtail (for Loki) configuration
curl -sSL -o shared/promtail/config.yml https://raw.githubusercontent.com/deeepak-tyagii/monitoring-observability-ai-agents/refs/heads/main/loki/config.yml

# Download Mimir configuration
curl -sSL -o shared/mimir/config.yaml https://raw.githubusercontent.com/deeepak-tyagii/monitoring-observability-ai-agents/refs/heads/main/mimir/config.yaml

# Download Grafana dashboard and provisioning files
curl -sSL -o shared/grafana/dashboards/ShoeHub_Dashboard.json https://raw.githubusercontent.com/deeepak-tyagii/monitoring-observability-ai-agents/refs/heads/main/grafana/ShoeHub_Dashboard.json
curl -sSL -o shared/grafana/provisioning/dashboards/dashboards.yml https://raw.githubusercontent.com/deeepak-tyagii/monitoring-observability-ai-agents/refs/heads/main/grafana/dashboards.yml
curl -sSL -o shared/grafana/provisioning/datasources/datasources.yml https://raw.githubusercontent.com/deeepak-tyagii/monitoring-observability-ai-agents/refs/heads/main/grafana/datasources.yml

# Create Tempo data folders if not exist
mkdir -p tempo-data/traces
mkdir -p tempo-data/wal

# Create Mimir data folder
mkdir -p mimir-data

# Set correct permissions
chmod -R 755 shared
chmod -R 777 tempo-data
chmod -R 777 mimir-data
chmod -R 777 shared/logs/shoehub
chmod -R 777 shared/loki/chunks
chmod -R 777 shared/loki/rules

echo "All files downloaded and permissions set."


echo "Now running: docker-compose up -d"

# Default to modern Docker Compose
DOCKER_CMD="docker compose"

# Check for legacy flag
if [[ "$1" == "--legacy" ]]; then
    DOCKER_CMD="docker-compose"
fi

# Run the command
$DOCKER_CMD -f docker-compose.yaml up -d
