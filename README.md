# AutomationFullStack: High-End Residential Automation & Enterprise Monitoring

## 1. Executive Summary
This project implements a multi-layered software stack for high-end residential automation, bridging robust local control (KNX/Zigbee) with scalable enterprise-grade remote monitoring. It is designed for a hybrid topology where an **AI Edge Node** (HP EliteDesk running Proxmox) operates autonomously, while telemetry is aggregated into a centralized **Diagnostic Home Lab**.

The system features a **Multi-Tenant Branding Engine** that dynamically adapts the UI for **ATS** and **Manara** brands.

## 2. Architecture Overview

### 2.1. Client-Side: The AI Edge Node
- **Hardware**: HP EliteDesk 800 G5 (Proxmox VE).
- **Core Components**:
    - **Home Assistant (LXC)**: Automation core with direct network access for KNX multicast.
    - **Frigate NVR**: AI object detection using Google Coral Edge TPU.
    - **Connectivity**: MQTT as the universal message bus; Cloudflare Tunnels (mTLS) for secure remote access without VPNs.

### 2.2. Installer-Side: The Diagnostic Home Lab
- **Stack**: TIG (Telegraf, InfluxDB v2, Grafana).
- **Data Strategy**: Tag-based segregation in InfluxDB v2 using Flux for "Deadman" checks and fleet monitoring.

## 3. Directory Structure

| Directory | Component | Description |
| :--- | :--- | :--- |
| `/web` | **Frontend** | Flutter-based "Computer Vision" interface. Features BLoC state management, WebSocket connectivity, and dynamic branding (ATS/Manara). |
| `/backend` | **Backend** | Python FastAPI "Sidecar" service. Handles MQTT Statestream ingestion, health monitoring, and brand logic enforcement. |
| `/data` | **Data Layer** | InfluxDB v2 configuration and Docker Compose setup for the diagnostic stack. |
| `/infra` | **Infrastructure** | Ansible playbooks for "Zero-Touch" provisioning of Proxmox containers and Cloudflare Tunnels. |

## 4. Branding Strategy
The system supports multi-tenancy through a **Server-Driven UI** approach:
- **Backend**: Serves a configuration payload (`brand_id`, `primary_color`, `logo_url`) upon authentication.
- **Frontend**: A `GlobalThemeProvider` consumes this payload to dynamically skin the application (e.g., "glowing" room cards for active states).

## 5. Security
- **Remote Access**: Cloudflare Tunnels with Mutual TLS (mTLS) and granular Access Policies.
- **Isolation**: Diagnostic processes run in a separate "Sentinel" loop to ensure they do not block critical automation logic.
